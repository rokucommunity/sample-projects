sub init()
  m.top.functionName = "fetch"
end sub

sub fetch()
  listContent = createObject("roSGNode", "ContentNode")
  request = createObject("roUrlTransfer")
  request.setCertificatesFile("common:/certs/ca-bundle.crt")
  request.initClientCertificates()
  ' Reddit 403s requests from a Roku (the firmware User-Agent can't be overridden), so this
  ' sample reads a captured snapshot of the subreddit's /.json response from a gist instead.
  request.setUrl("https://gist.githubusercontent.com/TwitchBronBron/93b638fbe0911e9e9cc3be6818b330e1/raw/fast_workers.json")
  response = request.getToString()
  json = parseJson(response)

  listItems = []
  for each postDataContainer in json.data.children
    postData = postDataContainer.data
    post = {
      title: postData.title,
      author: postData.author,
      thumbnail: postData.thumbnail,
      isVideo: postData.is_video,
      url: postData.url,
      isSelf: postData.isSelf
    }

    if post.isVideo then
      itemContent = {
        subType: "ContentNode"
        isSelf: post.isSelf
        title: post.title
        description: post.author
        url: post.url
      }

      if post.thumbnail <> "self" and post.thumbnail <> "default" and post.thumbnail <> "image" then
        itemContent.SDPosterUrl = post.thumbnail
      end if

      if post.isVideo and postData.media.reddit_video <> invalid and postData.media.reddit_video.dash_url <> invalid then
        itemContent.url = postData.media.reddit_video.dash_url
        itemContent.streamformat = "dash"
      else if postData.media <> invalid and postData.media.type = "youtube.com" then
        itemContent.url = postData.url
        itemContent.streamFormat = "youtube"
      end if

      itemContent.isRedditVideo = (postData.media <> invalid and postData.media.reddit_video <> invalid)

      listItems.push(itemContent)
    end if
  end for

  listContent.update(listItems, true)
  m.top.content = listContent
end sub
