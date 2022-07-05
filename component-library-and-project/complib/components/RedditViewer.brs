sub init()
  m.list = m.top.FindNode("list")
  m.list.observeField("itemSelected", "onItemSelected")
  updateList()
end sub

sub updateList()
  if m.progress = invalid then
    m.progress = createObject("roSGNode", "ProgressDialog")
    m.progress.title = "Loading..."
    m.progress.message = "Did you know:" + chr(10) + "You can use the replay key to update the list!"
    m.dialog = m.progress
  end if

  if m.subRedditRequest <> invalid then
    m.subRedditRequest.unobserveField("content")
  end if
  m.subRedditRequest = createObject("roSGNode", "GetSubReddit")
  m.subRedditRequest.subReddit = "/r/Roku"
  m.subRedditRequest.observeField("content", "onSubRedditRequestContentChange")
  m.subRedditRequest.control = "RUN"
end sub

sub onSubRedditRequestContentChange(event as object)
  content = event.getData()
  m.list.content = content
  m.list.setFocus(true)

  if m.progress <> invalid then
    m.progress.close = true
    m.progress = invalid
  end if

end sub

sub onItemSelected(event as object)
  post = event.getRoSGNode().content.getChild(event.getData())

  m.dialog = createObject("roSGNode", "Dialog")
  m. dialog.title = post.title
  m.dialog.message = post.description
  print post
end sub

function onKeyEvent(key as string, press as boolean) as boolean
  handled = false
  if not press then return handled

  if key = "back" then
    m.top.appExit = true
  else if key = "replay" then
    updateList()
  end if

  return handled
end function
