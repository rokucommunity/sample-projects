sub init()
  m.top.functionName = "fetch_bad"
  ' m.top.functionName = "fetch_good"
end sub

' This is an example of a function that is not mindful of rendezvous
sub fetch_bad()
  timeSpan = createObject("roTimeSpan")
  m.top.content = createObject("roSGNode", "ContentNode")
  request = createObject("roUrlTransfer")
  request.setCertificatesFile("common:/certs/ca-bundle.crt")
  request.initClientCertificates()
  request.setUrl("https://www.reddit.com" + m.top.subReddit + "/.json")
  response = request.getToString()
  json = parseJson(response)

  createRowItems(json, m.top.content)
  print "Task took: " + timeSpan.TotalMilliseconds().ToStr()
end sub


' This is an example of a function that avoids rendezvous
sub fetch_good()
  timeSpan = createObject("roTimeSpan")
  listContent = createObject("roSGNode", "ContentNode")
  request = createObject("roUrlTransfer")
  request.setCertificatesFile("common:/certs/ca-bundle.crt")
  request.initClientCertificates()
  request.setUrl("https://www.reddit.com" + m.top.subReddit + "/.json")
  response = request.getToString()
  json = parseJson(response)

  createRowItems(json, listContent)
  m.top.content = listContent
  print "Task took: " + timeSpan.TotalMilliseconds().ToStr()
end sub

sub createRowItems(json as Object, listContent as Object)
  for each postDataContainer in json.data.children
    postData = postDataContainer.data
    post = {
      title: postData.title,
      selfText: postData.selfText,
      thumbnail: postData.thumbnail,
      isVideo: postData.is_video,
      url: postData.url,
      isSelf: postData.isSelf
    }

    itemContent = listContent.createChild("ContentNode")
    itemContent.update({ isSelf: post.isSelf }, true)
    itemContent.title = post.title
    itemContent.description = post.selfText
    itemContent.url = post.url

    if post.thumbnail <> "self" and post.thumbnail <> "default" and post.thumbnail <> "image" then
      itemContent.SDPosterUrl = post.thumbnail
    end if

    if post.isVideo then
      itemContent.videoUrl = postData.secure_media.reddit_video.hls_url
      itemContent.streamformat = "hls"
    end if

    if postData.media <> invalid and postData.media.type = "youtube.com" then
      itemContent.videoUrl = postData.url
      itemContent.streamFormat = "youtube"
    end if

    extension = right(postData.url, 4)
    if extension = ".png" or extension = ".jpg" then
      itemContent.SDPosterUrl = postData.url
    end if

    itemContent.update({
      isRedditVideo: (postData.media <> invalid and postData.media.reddit_video <> invalid)
    }, true)
  end for
end sub
