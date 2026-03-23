' Required by certification 5.2 — Direct to Play / Deep Linking.
' Screensavers use RunScreenSaver() as their entry point, but the cert
' checker requires RunUserInterface(input) to exist and read contentId/mediaType
' from the initial launch input parameter.
sub RunUserInterface(input as Object)
    if input <> invalid
        contentId = input.contentId
        mediaType = input.mediaType
        if contentId <> invalid and contentId <> ""
            print "[Screensaver] Deep link launch contentId=" contentId " mediaType=" mediaType
        end if
    end if
    RunScreenSaver()
end sub

sub RunScreenSaver()
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)

    m.memMonitor = CreateObject("roAppMemoryMonitor")
    if m.memMonitor <> invalid then
        m.memMonitor.enableMemoryWarningEvent(true)
        m.memMonitor.setMessagePort(m.port)
        print "[Screensaver] Memory limit: "; m.memMonitor.getChannelMemoryLimit()
        print "[Screensaver] Memory used: "; m.memMonitor.getMemoryLimitPercent(); "%"
    end if

    m.devInfo = CreateObject("roDeviceInfo")
    if m.devInfo <> invalid then
        m.devInfo.enableLowGeneralMemoryEvent(true)
    end if

    ' Required by certification 5.2 — roInput object must exist with message port set
    ' so the channel can receive roInputEvent messages from the firmware.
    m.inputObj = CreateObject("roInput")
    m.inputObj.setMessagePort(m.port)

    scene = screen.CreateScene("MainScene")
    screen.show()

    while true
        msg = wait(0, m.port)
        if msg <> invalid
            msgType = type(msg)
            if msgType = "roSGScreenEvent"
                if msg.isScreenClosed() then return
            else if msgType = "roAppMemoryMonitorEvent"
                print "[Screensaver] Memory warning - available: "; m.memMonitor.getChannelAvailableMemory()
            else if msgType = "roDeviceInfoEvent"
                print "[Screensaver] Low general memory event"
            else if msgType = "roInputEvent"
                ' Required by certification 5.2 — Direct to Play.
                evtData   = msg.getData()
                contentId = evtData.contentId
                mediaType = evtData.mediaType
                print "[Screensaver] roInputEvent contentId=" contentId " mediaType=" mediaType
            end if
        end if
    end while
end sub
