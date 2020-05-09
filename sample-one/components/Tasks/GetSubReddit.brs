sub init()
  m.top.functionName = "fetch"
end sub

sub fetch()
  listContent = createObject("roSGNode", "ContentNode")
  request = createObject("roUrlTransfer")
  request.setCertificatesFile("common:/certs/ca-bundle.crt")
  request.initClientCertificates()
  request.setUrl("https://www.reddit.com" + m.top.subReddit + "/.json")
  response = request.getToString()
  json = parseJson(response)

  listItems = []
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

    itemContent = {
      subType: "ContentNode"
      isSelf: post.isSelf
      title: post.title
      description: post.selfText
      url: post.url
    }
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

    if postData.media <> invalid and postData.media.reddit_video <> invalid then
      itemContent.isRedditVideo = true
    else
      itemContent.isRedditVideo = false
    end if

    listItems.push(itemContent)
  end for

  listContent.update(listItems, true)
  m.top.content = listContent
end sub
