# Echo

Echo is a simple customizable logging framework for Swift. It allows you to add some useful details to the console logs such as the level flag, date, time, filename, function name and line number.

Before you `println("things")`:

```
things
```

Now you Echo `Echo.info("beautiful things")`:

```
💡 [11:05:58.013] [AppDelegate.swift:21] beautiful things
```

## Features

- [x] Log levels
- [x] Selective code execution
- [x] Customizable log format

---

## How to use

Drag `Echo.framework` on your project navigator (*Copy if needed*), make sure it appears in *Embedded Binaries* and *Linked Frameworks and Libraries* project sections.

Then:

```swift
import Echo
```

Instanciate an Echo or just use the shared instance:

```swift
var echo = Echo()
echo.info("info")

Echo.info("info")
```

### Echo levels

With Echo, each log level has its own method:

```swift
Echo.trace("Trace")
Echo.debug("Debug")
Echo.info("Info")
Echo.warn("Warn")
Echo.error("Error")
Echo.trace("Fatal")
```

Because Echo level is set to `.Trace` by default, all these logs are print to the console.

```
💊 [11:06:03.753] [AppDelegate.swift:20] Trace
☕️ [11:06:03.754] [AppDelegate.swift:21] Debug
💡 [11:06:03.754] [AppDelegate.swift:22] Info
⚠️ [11:06:03.755] [AppDelegate.swift:23] Warn
❌ [11:06:03.755] [AppDelegate.swift:23] Error
💣 [11:06:03.755] [AppDelegate.swift:25] Fatal
```

Naturally you can change Echo level to print only messages with a log level `>=`. So if you set Echo level like that:

```swift
Echo.level = .Warn
```

You will only show *warn*, *error* and *fatal* messages.

Echo also provide the possiblity to disable message logging by setting Echo level to `.Off`.

### Selective code execution

Echo `trace`, `debug`, `info`, `warn`, `error` and `fatal` methods can also be used to limit code execution in the same way you limit log printing.

```swift
Echo.trace({ () -> Double
  let AB = 1.0
  let AC = 2.0
  return sqrt(AB*AB + AC*AC) // BC
})
```

If Echo level is `<=` .Trace, Echo print the returned value to the console.

```
💊 [11:06:03.753] [AppDelegate.swift:20] 2.23606797749979
```

### Customize Echo format

Echo format is an array of `EchoComponent` that define how Echo logs are print to the console.

* `EchoComponent.DateTime`: Echo date and time.
* `EchoComponent.Flag`: Flag that identify Echo level.
* `EchoComponent.Filename`: Caller's filename.
* `EchoComponent.Function`: Caller's function name.
* `EchoComponent.Line`: Caller's line.
* `EchoComponent.Message`: Message to print.
* `EchoComponent.Separator`: Separator.

By default Echo format is set to:

```swift
Echo.format = [
  .Flag(flags: [.Trace: "💊", .Debug:  "☕️", .Info: "💡", .Warn: "⚠️", .Error: "❌", .Fatal: "💣", .Off: "😶"]),
  .Separator(" ["),
  .Datetime(format: "HH:mm:ss.SSS"),
  .Separator("] ["),
  .Filename,
  .Separator(":"),
  .Line,
  .Separator("] "),
  .Message
]
```

---

## Contact

[Clément Cyril](https://github.com/clmntcrl) ([@clmntcrl](https://twitter.com/clmntcrl))

## License

Echo is released under the MIT license. See LICENSE for details.
