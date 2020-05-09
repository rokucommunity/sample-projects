sub init()
  m.list = m.top.FindNode("list")
  m.list.observeField("itemSelected", "onItemSelected")
  updateList()
end sub

sub updateList()
  if m.progress = Invalid then
    m.progress = createObject("roSGNode", "ProgressDialog")
    m.progress.title = "Loading..."
    m.progress.message = "Did you know:" + chr(10) + "You can use the replay key to update the list!"
    m.top.dialog = m.progress
  end if

  if m.subRedditRequest <> Invalid then
    m.subRedditRequest.unobserveField("content")
  end if
  m.subRedditRequest = createObject("roSGNode", "GetSubReddit")
  m.subRedditRequest.subReddit = "/r/Roku"
  m.subRedditRequest.observeField("content", "onSubRedditRequestContentChange")
  m.subRedditRequest.control = "RUN"
end sub

sub onSubRedditRequestContentChange(event as Object)
  content = event.getData()
  m.list.content = content
  m.list.setFocus(true)

  if m.progress <> Invalid then
    m.progress.close = true
    m.progress = Invalid
  end if

end sub

sub onItemSelected(event as Object)
  post = event.getRoSGNode().content.getChild(event.getData())

  dialog = createObject("roSGNode", "Dialog")
  dialog.title = post.title
  dialog.message = post.description
  m.top.dialog = dialog
  print post
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
  handled = false
  if NOT press then return handled

  if key = "back" then
    m.top.appExit = true
  else if key = "replay" then
    updateList()
  end if

  return handled
end function
