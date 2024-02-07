sub init()
    gc_dumpSceneChildren("init")
    m.top.backgroundUri = "pkg://components/scene/bg.jpeg"
    gc_dumpSceneChildren("after setting")
end sub


function onKeyEvent(key as string, press as boolean) as boolean
    handled = false
    if not press then return handled

    if key <> "back" then
        imageUrl = "pkg://components/scene/bg.jpeg"
        if m.top.backgroundUri = imageUrl
            m.top.backgroundUri = ""
        else
            m.top.backgroundUri = imageUrl
        end if

        gc_dumpSceneChildren("updated BG to " + m.top.backgroundUri)
        return true
    end if

    return false
end function


function gc_dumpSceneChildren(message = "" as string)
    ? " DUMPING SCENE CHILDREN:: " message
    ? "---------------------------"
    scene = gc_getM().top.getScene()
    for i = 0 to scene.getChildCount() - 1
        ? "CHILD " i " " scene.getChild(i)?.id
    end for
    ? "---------------------------"
end function

function gc_getM()
    return m
end function