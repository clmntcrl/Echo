//  Echo by Clément Cyril - @clmntcrl - http://clmntcrl.io/
//  Copyright 2015 Clément Cyril. See LICENSE.

import Foundation

// MARK: Echo levels

public enum EchoLevel: UInt, Comparable {

    case Trace
    case Debug
    case Info
    case Warn
    case Error
    case Fatal
    case Off

}

public func <(lhs: EchoLevel, rhs: EchoLevel) -> Bool {
    return lhs.rawValue < rhs.rawValue
}
public func ==(lhs: EchoLevel, rhs: EchoLevel) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

// MARK: Echo components

public enum EchoComponent {

    case Datetime(format: String)
    case Flag(flags: [EchoLevel: String])
    case Filename
    case Function
    case Line
    case Message
    case Separator(String)

}

// MARK: Echo

public struct Echo {

    public var format: [EchoComponent] = [
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
    public var level: EchoLevel = .Trace
    public var reflect: (String) -> Void = { println($0) }

    private let dateFormatter = NSDateFormatter()


    public init() {
    }

    public func reflectable(level: EchoLevel) -> Bool {
        return level >= self.level
    }
    public func compose<T>(level : EchoLevel, value: T, file: StaticString, function: StaticString, line: UWord) -> String {
        return format.map({ component -> String in
            switch component {
            case .Datetime(let format):
                self.dateFormatter.dateFormat = format
                return self.dateFormatter.stringFromDate(NSDate())
            case .Flag(let flags):
                return  (flags as [EchoLevel: String])[level] ?? "" // FIXME: Type can't be inferred ???
            case .Filename:
                return "\(file)".lastPathComponent
            case .Function:
                return "\(function)"
            case .Line:
                return "\(line)"
            case .Message:
                return "\(value)"
            case .Separator(let separator):
                return separator
            }
        }).reduce("", combine: +)
    }

    // MAK: Echo values

    private func echo<T>(level: EchoLevel, value: T, file: StaticString, function: StaticString, line: UWord) -> String? {
        if reflectable(level) {
            let log = compose(level, value: value, file: file, function: function, line: line)
            reflect(log)
            return log
        }
        return nil
    }

    public func trace<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) -> String? {
        return echo(.Trace, value: value, file: file, function: function, line: line)
    }
    public func debug<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) -> String? {
        return echo(.Debug, value: value, file: file, function: function, line: line)
    }
    public func info<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) -> String? {
        return echo(.Info, value: value, file: file, function: function, line: line)
    }
    public func warn<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) -> String? {
        return echo(.Warn, value: value, file: file, function: function, line: line)
    }
    public func error<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) -> String? {
        return echo(.Error, value: value, file: file, function: function, line: line)
    }
    public func fatal<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) -> String? {
        return echo(.Fatal, value: value, file: file, function: function, line: line)
    }

    // MAK: Echo closures
    // TODO: Find a better way for selective code execution to avoid code repetition

    private func echo<T>(level: EchoLevel, closure: () -> T, file: StaticString, function: StaticString, line: UWord) -> String? {
        if reflectable(level) {
            let log = compose(level, value: closure(), file: file, function: function, line: line)
            reflect(log)
            return log
        }
        return nil
    }

    public func trace<T>(closure: () -> T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) -> String? {
        return echo(.Trace, closure: closure, file: file, function: function, line: line)
    }
    public func debug<T>(closure: () -> T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) -> String? {
        return echo(.Debug, closure: closure, file: file, function: function, line: line)
    }
    public func info<T>(closure: () -> T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) -> String? {
        return echo(.Info, closure: closure, file: file, function: function, line: line)
    }
    public func warn<T>(closure: () -> T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) -> String? {
        return echo(.Warn, closure: closure, file: file, function: function, line: line)
    }
    public func error<T>(closure: () -> T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) -> String? {
        return echo(.Error, closure: closure, file: file, function: function, line: line)
    }
    public func fatal<T>(closure: () -> T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) -> String? {
        return echo(.Fatal, closure: closure, file: file, function: function, line: line)
    }

}
