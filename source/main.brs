sub RunScreenSaver(args as Object)
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)

    m.input = CreateObject("roInput")
    m.input.setMessagePort(m.port)

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

    scene.signalBeacon("AppLaunchComplete")

    while true
        msg = wait(0, m.port)
        msgType = type(msg)

        if msgType = "roSGScreenEvent" then
            if msg.isScreenClosed() then return
        else if msgType = "roInputEvent" then
            return
        else if msgType = "roAppMemoryMonitorEvent" then
            if msg.isMemoryWarning() then
                print "[Screensaver] Memory warning - available: "; m.memMonitor.getChannelAvailableMemory()
            end if
        else if msgType = "roDeviceInfoEvent" then
            print "[Screensaver] Low general memory event"
        end if
    end while
end sub

sub Main(args as Dynamic)
    RunScreenSaver(args)
end sub
