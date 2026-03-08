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
            end if
        end if
    end while
end sub
