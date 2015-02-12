# Echo

Echo is a simple customizable logging framework for Swift. It allows you to add some useful details to the console logs such as the level flag, date, time, filename, function name and line number.

Before you `println("things")`:

```
things
```

Now you Echo `echo.info("beautiful things")`:

```
💡 [2014-12-08 10:20:01.000] [AppDelegate.swift:21] beautiful things
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

And just instanciate an Echo:

```swift
var echo = Echo()
echo.info("info")
```

### Echo levels

With Echo, each log level has its own method:

```swift
echo.trace("Trace")
echo.debug("Debug")
echo.info("Info")
echo.warn("Warn")
echo.error("Error")
echo.trace("Fatal")
```

Because Echo level is set to `.Trace` by default, all these logs are print to the console.

```
💊 [2014-12-08 10:20:01.000] [AppDelegate.swift:20] Trace
☕️ [2014-12-08 10:20:01.000] [AppDelegate.swift:21] Debug
💡 [2014-12-08 10:20:01.000] [AppDelegate.swift:22] Info
⚠️ [2014-12-08 10:20:01.000] [AppDelegate.swift:23] Warn
❌ [2014-12-08 10:20:01.000] [AppDelegate.swift:23] Error
💣 [2014-12-08 10:20:01.000] [AppDelegate.swift:25] Fatal
```

Naturally you can change Echo level to print only messages with a log level `>=`. So if you set Echo level like that:

```swift
echo.level = .Warn
```

You will only show *warn*, *error* and *fatal* messages.

Echo also provide the possiblity to disable message logging by setting Echo level to `.Off`.

### Selective code execution

Echo `trace`, `debug`, `info`, `warn`, `error` and `fatal` methods can also be used to limit code execution in the same way you limit log printing.

```swift
echo.trace({ () -> Double in
  let AB = 1.0
  let AC = 2.0
  return sqrt(AB*AB + AC*AC) // BC
})
```

If Echo level is `<=` .Trace, Echo print the returned value to the console.

```
💊 [2014-12-08 10:20:01.000] [AppDelegate.swift:20] 2.23606797749979
```

### Customize Echo format

Echo format is an array of `EchoComponent` that define how Echo logs are print to the console. 

By default Echo format is set to:

```swift
echo.format = [
  .Flag(flags: [.Trace: "💊", .Debug:  "☕️", .Info: "💡", .Warn: "⚠️", .Error: "❌", .Fatal: "💣", .Off: "😶"]),
  .Separator(" ["),
  .Datetime(format: "yyyy-MM-dd HH:mm:ss.SSS"),
  .Separator("] ["),
  .Filename,
  .Separator(":"),
  .Line,
  .Separator("] "),
  .Message
]
```

Available `EchoComponent` values:

* `EchoComponent.Datetime(format: String)`: cf. `NSDateFormatter.dateFormat`
* `EchoComponent.Flag(flags: [EchoLevel: EchoFlag])`
* `EchoComponent.Filename`
* `EchoComponent.Function`
* `EchoComponent.Line`
* `EchoComponent.Message`
* `EchoComponent.Separator(String)`

---

## Contact

[Clément Cyril](https://github.com/clmntcrl) ([@clmntcrl](https://twitter.com/clmntcrl))

## License

Echo is released under the MIT license. See LICENSE for details.
