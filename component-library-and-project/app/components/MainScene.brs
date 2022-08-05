sub init()
    loadComplib()
end sub

sub loadComplib()
    componentLibrary = m.top.createChild("ComponentLibrary")
    componentLibrary.observeFieldScoped("loadStatus", "onComponentLibraryLoadStatusChange")
    'get the complib url from the manifest
    componentLibrary.uri = createObject("roAppInfo").GetValue("complib_url")
end sub

' observe the ComponentLibrary's loadStatus
sub onComponentLibraryLoadStatusChange(event as object)
    status = event.getData()
    component = event.getRoSgNode()
    print "Complib loadStatus: ", status

    'complib has started loading (but isn't ready yet)
    if status = "loading" then return

    if status = "ready" then
        'Complib has loaded and is ready to use
        render()
    else
        'there was an error loading the complib
        m.dialog = createObject("roSGNode", "Dialog")
        'show a popup explaining that the complib failed to load
        m.dialog.update({
            title: "Error!",
            message: "Failed to load component library"
        })
    end if
end sub

sub render()
    m.top.createChild("SampleComplib:RedditViewer")
end sub
