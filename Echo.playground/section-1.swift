// Playground - noun: a place where people can play

import XCPlayground
import Foundation


import Echo


// Declare an echo

var echo = Echo()

// Customize its log format

echo.format = "\(EchoComponent.Flag) [\(EchoComponent.DateTime)] [\(EchoComponent.Filename):\(EchoComponent.Line)][\(EchoComponent.Function)] \(EchoComponent.Message)"
echo.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"

// Change log Level

echo.level = .Info

// Now, Echo like you println

echo.warn("warn") // using an echo instance

Echo.info("trace") // or just use the echo shared instance
