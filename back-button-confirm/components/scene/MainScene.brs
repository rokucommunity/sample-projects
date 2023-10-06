sub init()
end sub

function onKeyEvent(key as string, press as boolean) as boolean
  if press and key = "back" then
    'create the dialog
    dialog = createObject("roSGNode", "StandardMessageDialog")
    '.message is an array of messages
    dialog.message = ["Do you really want to exit?"]
    dialog.buttons = ["Yes", "No"]
    'register a callback function for when a user clicks a button
    dialog.observeFieldScoped("buttonSelected", "onDialogButtonClick")

    'assigning the dialog to m.top.dialog will "show" the dialog
    m.top.dialog = dialog
    return true
  end if
end function

function onDialogButtonClick(evt)
  buttonIndex = evt.getData()
  'did the user click "Yes"
  if buttonIndex = 0 then
    'set appExit which will kill the channel in the main loop
    m.top.appExit = true

  'user clicked "no"
  else
      'close the dialog
      m.top.dialog.close = true
      return true
  end if
end function
