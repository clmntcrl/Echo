//
//  Echo.swift
//  Echo
//
//  Created by clmntcrl on 03/12/2014.
//  Copyright (c) 2014 Clément Cyril. All rights reserved.
//


import Foundation


// MARK: Echo types

public typealias EchoFlag = String

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
    case Flag(flags: [EchoLevel: EchoFlag])
    case Filename
    case Function
    case Line
    case Message
    case Separator(String)

}

// MARK: Echo log controller

public struct Echo {

    private static var sharedInstance = Echo()

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
    public static var format: [EchoComponent] {
        get {
            return sharedInstance.format
        }
        set {
            sharedInstance.format = newValue
        }
    }
    private var dateFormatter = NSDateFormatter()

    public var level = EchoLevel.Trace
    public static var level: EchoLevel {
        get {
            return sharedInstance.level
        }
        set {
            sharedInstance.level = newValue
        }
    }


    public init() {
        
    }

    private func isLoggable(level: EchoLevel) -> Bool {
        return level >= self.level
    }
    private func echo<T>(value: T, _ level: EchoLevel, _ file: StaticString, _ function: StaticString, _ line: UWord) {
        if isLoggable(level) {
            log(value, level, file, function, line)
        }
    }
    private func echo<T>(closure: () -> T, _ level: EchoLevel, _ file: StaticString, _ function: StaticString, _ line: UWord) {
        if isLoggable(level) {
            log(closure(), level, file, function, line)
        }
    }
    private func log<T>(value: T, _ level: EchoLevel, _ file: StaticString, _ function: StaticString, _ line: UWord) {
        var log = format.map({ component -> String in
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

        println(log)
    }

}

// MARK: Echo trace methods

extension Echo {

    public func trace<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        echo(value, .Trace, file, function, line)
    }
    public func trace<T>(closure: () -> T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        echo(closure, .Trace, file, function, line)
    }

    public static func trace<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.echo(value, .Trace, file, function, line)
    }
    public static func trace<T>(closure: () -> T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.echo(closure, .Trace, file, function, line)
    }

}

// MARK: Echo debug methods

extension Echo {
    
    public func debug<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        echo(value, .Debug, file, function, line)
    }
    public func debug<T>(closure: () -> T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        echo(closure, .Debug, file, function, line)
    }

    public static func debug<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.echo(value, .Debug, file, function, line)
    }
    public static func debug<T>(closure: () -> T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.echo(closure, .Debug, file, function, line)
    }

}

// MARK: Echo info methods

extension Echo {

    public func info<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        echo(value, .Info, file, function, line)
    }
    public func info<T>(closure: () -> T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        echo(closure, .Info, file, function, line)
    }

    public static func info<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.echo(value, .Info, file, function, line)
    }
    public static func info<T>(closure: () -> T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.echo(closure, .Info, file, function, line)
    }

}

// MARK: Echo warn methods

extension Echo {

    public func warn<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        echo(value, .Warn, file, function, line)
    }
    public func warn<T>(closure: () -> T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        echo(closure, .Warn, file, function, line)
    }

    public static func warn<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.echo(value, .Warn, file, function, line)
    }
    public static func warn<T>(closure: () -> T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.echo(closure, .Warn, file, function, line)
    }

}

// MARK: Echo error methods

extension Echo {

    public func error<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        echo(value, .Error, file, function, line)
    }
    public func error<T>(closure: () -> T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        echo(closure, .Error, file, function, line)
    }

    public static func error<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.echo(value, .Error, file, function, line)
    }
    public static func error<T>(closure: () -> T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.echo(closure, .Error, file, function, line)
    }

}

// MARK: Echo fatal methods

extension Echo {

    public func fatal<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        echo(value, .Fatal, file, function, line)
    }
    public func fatal<T>(closure: () -> T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        echo(closure, .Fatal, file, function, line)
    }

    public static func fatal<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.echo(value, .Fatal, file, function, line)
    }
    public static func fatal<T>(closure: () -> T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.echo(closure, .Fatal, file, function, line)
    }

}
