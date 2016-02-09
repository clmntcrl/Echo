//  Echo by Clément Cyril - @clmntcrl - http://clmntcrl.io/
//  Copyright 2015 Clément Cyril. See LICENSE.

import Foundation

// MARK: - Echo levels

public enum EchoLevel: UInt, Comparable {

    case Trace, Debug, Info, Warn, Error, Fatal, Off
}
public func <(lhs: EchoLevel, rhs: EchoLevel) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

// MARK: - Echo components

public enum EchoComponent {

    case Name
    case Datetime(String)
    case Flag([EchoLevel: String])
    case Filename
    case Function
    case Line
    case Message
    case Separator(String)
}

// MARK: - Propagator protocol

public protocol Propagator_ {

    var name: String { get }
    var format: [EchoComponent] { get }
    var level: EchoLevel { get set }

    var reverb: String -> Void { get }

    func propagate(level: EchoLevel, datetime: NSDate, filename: String, function: String, line: Int, source: () -> Any)

    func trace(value: Any, file: String, function: String, line: Int)
    func trace(file: String, function: String, line: Int, closure: () -> Any)
    func debug(value: Any, file: String, function: String, line: Int)
    func debug(file: String, function: String, line: Int, closure: () -> Any)
    func info(value: Any, file: String, function: String, line: Int)
    func info(file: String, function: String, line: Int, closure: () -> Any)
    func warn(value: Any, file: String, function: String, line: Int)
    func warn(file: String, function: String, line: Int, closure: () -> Any)
    func error(value: Any, file: String, function: String, line: Int)
    func error(file: String, function: String, line: Int, closure: () -> Any)
    func fatal(value: Any, file: String, function: String, line: Int)
    func fatal(file: String, function: String, line: Int, closure: () -> Any)
}

// MARK: Echo propagator protocol extension

private let defaultEchoFormat: [EchoComponent] = [.Flag([.Trace: "💊", .Debug:  "☕️", .Info: "💡", .Warn: "⚠️", .Error: "❌", .Fatal: "💣"]),
                                                  .Separator(" ["),
                                                  .Datetime("HH:mm:ss.SSS"),
                                                  .Separator("] ["),
                                                  .Filename,
                                                  .Separator(":"),
                                                  .Line,
                                                  .Separator("] "),
                                                  .Message]
private let dateFormatter = NSDateFormatter()
private let echoQueue = dispatch_queue_create("io.clmntcrl.echo.queue", .None)

public extension Propagator_ {

    var name: String { return String(Self) }
    var format: [EchoComponent] { return defaultEchoFormat }

    func propagate(level: EchoLevel, datetime: NSDate, filename: String, function: String, line: Int, source: () -> Any) {
        guard level >= self.level else {
            return
        }

        dispatch_async(echoQueue) {
            self.reverb(self.format.map {
                switch $0 {
                case .Name:
                    return self.name
                case .Datetime(let format):
                    dateFormatter.dateFormat = format
                    return dateFormatter.stringFromDate(datetime)
                case .Flag(let flags):
                    return  flags[level] ?? ""
                case .Filename:
                    return filename
                case .Function:
                    return function
                case .Line:
                    return String(line)
                case .Message:
                    return "\(source())"
                case .Separator(let s):
                    return s
                }
            }.reduce("", combine: +))
        }
    }

    func trace(value: Any, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
        propagate(.Trace, datetime: NSDate(), filename: NSURL(string: file)?.lastPathComponent ?? "", function: function, line: line, source: { value })
    }
    func trace(file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__, closure: () -> Any) {
        propagate(.Trace, datetime: NSDate(), filename: NSURL(string: file)?.lastPathComponent ?? "", function: function, line: line, source: closure)
    }
    func debug(value: Any, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
        propagate(.Debug, datetime: NSDate(), filename: NSURL(string: file)?.lastPathComponent ?? "", function: function, line: line, source: { value })
    }
    func debug(file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__, closure: () -> Any) {
        propagate(.Debug, datetime: NSDate(), filename: NSURL(string: file)?.lastPathComponent ?? "", function: function, line: line, source: closure)
    }
    func info(value: Any, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
        propagate(.Info, datetime: NSDate(), filename: NSURL(string: file)?.lastPathComponent ?? "", function: function, line: line, source: { value })
    }
    func info(file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__, closure: () -> Any) {
        propagate(.Info, datetime: NSDate(), filename: NSURL(string: file)?.lastPathComponent ?? "", function: function, line: line, source: closure)
    }
    func warn(value: Any, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
        propagate(.Warn, datetime: NSDate(), filename: NSURL(string: file)?.lastPathComponent ?? "", function: function, line: line, source: { value })
    }
    func warn(file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__, closure: () -> Any) {
        propagate(.Warn, datetime: NSDate(), filename: NSURL(string: file)?.lastPathComponent ?? "", function: function, line: line, source: closure)
    }
    func error(value: Any, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
        propagate(.Error, datetime: NSDate(), filename: NSURL(string: file)?.lastPathComponent ?? "", function: function, line: line, source: { value })
    }
    func error(file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__, closure: () -> Any) {
        propagate(.Error, datetime: NSDate(), filename: NSURL(string: file)?.lastPathComponent ?? "", function: function, line: line, source: closure)
    }
    func fatal(value: Any, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
        propagate(.Fatal, datetime: NSDate(), filename: NSURL(string: file)?.lastPathComponent ?? "", function: function, line: line, source: { value })
    }
    func fatal(file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__, closure: () -> Any) {
        propagate(.Fatal, datetime: NSDate(), filename: NSURL(string: file)?.lastPathComponent ?? "", function: function, line: line, source: closure)
    }
}

// MARK: - Echo propagator

public struct Propagator: Propagator_ {

    public let name: String
    public let format: [EchoComponent]
    public var level: EchoLevel = .Trace

    public let reverb: String -> Void

    public init(name: String, format: [EchoComponent], reverb: String -> Void) {
        self.name = name
        self.format = format
        self.reverb = reverb
    }
}

// MARK: - Some echo propagators

// MARK: Console

public func consolePropagator(name: String = "Console", format: [EchoComponent] = defaultEchoFormat) -> Propagator {
    return Propagator(name: name, format: format) { print($0) }
}

public func batmanConsolePropagator() -> Propagator {
    let batmanEchoFormat: [EchoComponent] = [.Separator("I'm Batman! ["),
                                             .Datetime("HH:mm:ss.SSS"),
                                             .Separator("] ["),
                                             .Filename,
                                             .Separator(":"),
                                             .Line,
                                             .Separator("]")]
    return consolePropagator("Batman", format: batmanEchoFormat)
}

// MARK: Local notification

#if os(iOS)
import UIKit

public func localNotificationPropagator(name: String = "Console", format: [EchoComponent] = defaultEchoFormat) -> Propagator {
    UIApplication.sharedApplication()
                 .registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert, categories: .None))

    return Propagator(name: name, format: format) {
        let notification = UILocalNotification()
        if #available(iOS 8.2, *) {
            notification.alertTitle = "Echo"
        }
        notification.alertBody = $0
        notification.hasAction = false
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
}
#endif