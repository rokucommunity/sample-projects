sub init()
    'get notified anytime the focus changes
    m.focusRing = m.top.findNode("focusRing")

    m.nodesToFocus = [
        m.top.findNode("red"),
        m.top.findNode("green"),
        m.top.findNode("blue")
        m.top.findNode("black")
    ]
    m.nodesToFocus[0].setFocus(true)
    m.top.observeField("focusedChild", "onFocusedChildChange")
end sub

'draw a focus ring around the focused element
sub onFocusedChildChange()
    print "focus has changed"
    focusedChild = m.top.focusedChild

    'if we have a focusedChild and it's not the main scene (which has no ID)
    if focusedChild <> invalid and focusedChild.id <> "" then
        print "Currently focused element: " + focusedChild.id
        m.focusRing.translation = [
            focusedChild.translation[0] - 5,
            focusedChild.translation[1] - 5
        ]
    end if
end sub

'Set focus to the next sibling in the specified direction
sub focusNextSibling()
    nodeToFocus = invalid

    'focus the next child
    for i = 0 to m.nodesToFocus.count() - 1
        child = m.nodesToFocus[i]
        'skip the focusRing
        if child.id = "focusRing"
            continue for
        end if

        if child.hasFocus()
            nodeToFocus = m.nodesToFocus[i + 1]
            exit for
        end if
    end for
    'if we have no node to focus, then focus the first node that's not the focusRing
    if nodeToFocus = invalid
        nodeToFocus = m.nodesToFocus[0]
    end if
    nodeToFocus.setFocus(true)
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    'only handle key up events
    if press <> true
        return false
    end if

    'simple focus management for now, just move forwards or backwards
    if key = "up" or key = "right" or key = "down" or key = "left"
        focusNextSibling()
        return true
    end if

    if key = "OK" then
        print "Item was selected", m.focusedChild.id
        return true
    end if
    return false
end function
