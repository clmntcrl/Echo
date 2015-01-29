import XCPlayground
import Foundation

import Echo

// Declare an echo

var echo = Echo()

// Customize its log format

echo.format = [
    .Separator("("),
    .Flag(flags: [.Trace: "💊", .Debug:  "☕️", .Info: "💡", .Warn: "⚠️", .Error: "❌", .Fatal: "💣", .Off: "😶"]),
    .Separator(") ["),
    .Datetime(format: "HH:mm:ss.SSS"),
    .Separator("] ["),
    .Filename,
    .Separator(":"),
    .Line,
    .Separator("]["),
    .Function,
    .Separator("] "),
    .Message
]

// Change log Level

echo.level = .Info

// Now, Echo like you println

echo.warn("warn") // using an echo instance

Echo.info("trace") // or just use the echo shared instance

// Want more?

Echo.debug({ () -> Double in
    let AB = 1.0
    let AC = 2.0
    return sqrt(AB*AB + AC*AC) // BC
})
