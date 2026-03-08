sub init()
    m.countdownLabel = m.top.findNode("countdownLabel")
    m.yearLabel = m.top.findNode("yearLabel")
    m.sparkle = m.top.findNode("sparkle")

    ' Determine the target year (end of current year = start of next year)
    now = CreateObject("roDateTime")
    now.toLocalTime()
    m.targetYear = now.getYear() + 1

    m.yearLabel.text = "Until " + m.targetYear.toStr().trim() + " arrives"

    ' Precompute end-of-year epoch (Jan 1 00:00:00 UTC of next year)
    m.endOfYearSeconds = getEndOfYearEpoch(m.targetYear)

    ' Update immediately then start 1-second timer
    updateCountdown()

    m.timer = m.top.createChild("Timer")
    m.timer.duration = 1
    m.timer.repeat = true
    m.timer.observeField("fire", "onTimerFire")
    m.timer.control = "start"

    ' Sparkle pulse animation
    m.pulseUp = m.top.createChild("Animation")
    m.pulseUp.duration = 1.5
    m.pulseUp.repeat = true
    m.pulseUp.easeFunction = "inOutCubic"

    interpUp = m.pulseUp.createChild("FloatFieldInterpolator")
    interpUp.fieldToInterp = "sparkle.opacity"
    interpUp.key = [0.0, 0.5, 1.0]
    interpUp.keyValue = [0.0, 0.6, 0.0]
    m.pulseUp.control = "start"

    m.top.setFocus(true)
end sub

sub onLaunchArgs()
    ' No-op: screensavers don't support deep linking but SCA requires the handler
end sub

' Compute epoch seconds for Jan 1 00:00:00 UTC of the given year.
' Uses a brute-force accumulation from the Unix epoch (1970).
function getEndOfYearEpoch(year as Integer) as LongInteger
    ' Seconds per day
    spd& = 86400

    ' Count days from 1970-01-01 to <year>-01-01
    totalDays& = 0
    for y = 1970 to year - 1
        if isLeapYear(y) then
            totalDays& = totalDays& + 366
        else
            totalDays& = totalDays& + 365
        end if
    end for

    return totalDays& * spd&
end function

function isLeapYear(y as Integer) as Boolean
    return (y MOD 4 = 0 AND y MOD 100 <> 0) OR (y MOD 400 = 0)
end function

sub onTimerFire()
    updateCountdown()
end sub

sub updateCountdown()
    now = CreateObject("roDateTime")
    nowSeconds& = now.asSeconds()

    remaining& = m.endOfYearSeconds - nowSeconds&

    if remaining& <= 0 then
        ' Happy new year! Reset to next year
        m.targetYear = m.targetYear + 1
        m.yearLabel.text = "Until " + m.targetYear.toStr().trim() + " arrives"
        m.endOfYearSeconds = getEndOfYearEpoch(m.targetYear)
        remaining& = m.endOfYearSeconds - nowSeconds&
    end if

    days% = remaining& \ 86400
    remaining& = remaining& MOD 86400
    hours% = remaining& \ 3600
    remaining& = remaining& MOD 3600
    mins% = remaining& \ 60
    secs% = remaining& MOD 60

    ' Format with leading zeros
    countdownStr = zeroPad(days%, 3) + " : " + zeroPad(hours%, 2) + " : " + zeroPad(mins%, 2) + " : " + zeroPad(secs%, 2)

    m.countdownLabel.text = countdownStr
end sub

function zeroPad(value as Integer, width as Integer) as String
    s = value.toStr().trim()
    while s.len() < width
        s = "0" + s
    end while
    return s
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false
    if key = "back" then
        m.top.exitChannel = true
        return true
    end if
    return false
end function
