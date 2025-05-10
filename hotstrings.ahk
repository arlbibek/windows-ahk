#Requires AutoHotkey v2.0

; == HOTSTRINGS ==

getGreeting() {
    greetings := [
        "Have a delightful day ahead! ",
        "Wishing you a wonderful day. ",
        "May your day be filled with joy. ",
        "Have an amazing day. ",
        "Hope you have a fantastic day! ",
        "Wishing you a great day ahead. ",
        "Enjoy your day to the fullest. ",
        "Wishing you a day full of positivity and success. ",
        "Hope today brings you closer to your goals. ",
        "Wishing you a day filled with pleasant surprises. ",
        "Have a productive and cheerful day! ",
        "May your day be full of accomplishments and smiles. ",
        "May your day be filled with inspiration and success. ",
        "Hope today is the start of something amazing for you. ",
        "Wishing you a stress-free and joyful day! ",
        "Have a peaceful and fulfilling day ahead. ",
    ]
    greetingIndex := Random(1, greetings.Length)
    return greetings[greetingIndex]
}

; ; Current date and time
sendFormattedDt(format, datetime := "") {
    if (datetime = "") {
        datetime := A_Now
    }
    SendText(FormatTime(datetime, format))
    return
}

; == Date and time

::/datetime:: {
    sendFormattedDt("dddd, MMMM dd, yyyy, HH:mm") ; Sunday, September 24, 2023, 16:31
}
::/dt:: {
    sendFormattedDt("dddd, MMMM dd, yyyy, HH:mm") ; Sunday, September 24, 2023, 16:31
}
::/time:: {
    sendFormattedDt("HH:mm") ; 16:31
}
::/date:: {
    sendFormattedDt("MMMM dd, yyyy") ; September 24, 2023
}
::/week:: {
    sendFormattedDt("dddd") ; Sunday
}
::/day:: {
    sendFormattedDt("dd") ; 24
}
::/month:: {
    sendFormattedDt("MMMM") ; September
}
::/mth:: {
    sendFormattedDt("MM") ; 09
}
::/year:: {
    sendFormattedDt("yyyy") ; 2023
}

; == Others

::wtf::Wow that's fantastic
::/paste:: {
    SendInput(A_Clipboard)
}
::/cud:: {
    SendText("/mnt/c/Users/" A_UserName)
}
::/gm::Good morning
::/ge::Good evening
::/gn::Good night
::/ty::Thank you very much
::/wc::Welcome
::/mp::My pleasure
::/lorem::Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
::/plankton::Plankton are the diverse collection of organisms found in water that are unable to propel themselves against a current. The individual organisms constituting plankton are called plankters. In the ocean, they provide a crucial source of food to many small and large aquatic organisms, such as bivalves, fish and whales.

; work

::/dear:: {
    ; Get the current hour
    currentHour := A_Hour

    ; Determine the time-based greeting
    if (currentHour < 12) {
        timeOfDayGreeting := "Good morning,"
    } else if (currentHour < 18) {
        timeOfDayGreeting := "Good afternoon,"
    } else {
        timeOfDayGreeting := "Good evening,"
    }

    ; Send the date and time-based greeting
    Send("Dear Mr/Ms. `n`n" timeOfDayGreeting " I hope that this email finds you well. `n`n")
    Send("...`n`n")

    ; Send the selected greeting
    SendText(getGreeting() "Thank you. ")
}

::/si::Shikhar Insurance
::/sicl::Shikhar Insurance Company Limited
::/siaddr:: {
    SendInput("Shikhar Biz Centre, Thapathali, Kathmandu, Nepal")
}
:*:/sicl.com::Shikhar Insurance
:*:@shi::@shikharinsurce.com

:*:/pfa:: Please find the attachment.
:*:/mail::bibek.aryal@shikharinsurance.com
:*:/iso::Information Security Officer
:*:/ph::9860277634
:*:/addr:: {
    SendInput("Tarakeshowr 05, Kathmandu, Nepal")
}
; names
:*:/ba::Bibek Aryal
:*:/rmm::Ramin Man Maharjan
:*:/dpp::Dip Prakash Panday
:*:/srb::Suraj Rajbahak