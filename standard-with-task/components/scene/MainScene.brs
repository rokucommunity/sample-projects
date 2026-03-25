sub init()
  m.video = m.top.FindNode("video")
  m.list = m.top.FindNode("list")
  m.list.observeField("itemSelected", "onItemSelected")
  updateList()
end sub

sub updateList()
  if m.progress = invalid then
    m.progress = createObject("roSGNode", "ProgressDialog")
    m.progress.title = "Loading..."
    m.progress.message = "Did you know:" + chr(10) + "You can use the replay key to update the list!"
    m.top.dialog = m.progress
  end if

  if m.subRedditRequest <> invalid then
    m.subRedditRequest.unobserveField("content")
  end if
  m.subRedditRequest = createObject("roSGNode", "GetSubReddit")
  m.subRedditRequest.subReddit = "/r/FastWorkers"
  m.subRedditRequest.observeField("state", "onSubRedditRequestContentChange")
  m.subRedditRequest.control = "RUN"
end sub

sub onSubRedditRequestContentChange(event as object)
  state = lCase(event.getData())
  if state = "stop" or state = "done" then
    content = event.getRoSGNode().content
    m.list.content = content
    m.list.setFocus(true)

    if m.progress <> invalid then
      m.progress.close = true
      m.progress = invalid
    end if
  end if
end sub

sub onItemSelected(event as object)
  post = event.getRoSGNode().content.getChild(event.getData())
  print post

  m.video.content = post
  m.video.control = "play"
  m.video.visible = true
end sub

function onKeyEvent(key as string, press as boolean) as boolean
  handled = false
  if not press then return handled

  if key = "back" then
    if m.video.visible then
      m.video.control = "stop"
      m.video.visible = false
      m.list.setFocus(true)
      handled = true
    else
      m.top.appExit = true
    end if
  else if key = "replay" then
    updateList()
  end if

  return handled
end function
