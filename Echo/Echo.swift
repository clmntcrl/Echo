//
//  Echo.swift
//  Echo
//
//  Created by clmntcrl on 03/12/2014.
//  Copyright (c) 2014 Clément Cyril. All rights reserved.
//


import Foundation


// MARK: Log levels

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

extension EchoLevel: Printable {

    public var description: String {
        switch self {
        case Trace:
            return "[trace]"
        case Debug:
            return "[debug]"
        case Info:
            return "[info]"
        case Warn:
            return "[warn]"
        case Error:
            return "[error]"
        case Fatal:
            return "[fatal]"
        case Off:
            return "[off]"
        }
    }

}

// MARK: Log format elements

public enum EchoComponent {

    case DateTime
    case Flag
    case Filename
    case Function
    case Line
    case Message

}

extension EchoComponent: Printable {

    public var description: String {
        switch self {
        case .DateTime:
            return "[datetime]"
        case .Flag:
            return "[flag]"
        case .Filename:
            return "[filename]"
        case .Function:
            return "[function]"
        case .Line:
            return "[line]"
        case .Message:
            return "[message]"
        }
    }

}

// MARK: Log controller

public struct Echo {

    private static var sharedInstance = Echo()

    public var format = "\(EchoComponent.Flag) [\(EchoComponent.DateTime)] [\(EchoComponent.Filename):\(EchoComponent.Line)]\t\(EchoComponent.Message)"
    public static var format: String {
        get {
            return sharedInstance.format
        }
        set {
            sharedInstance.format = newValue
        }
    }
    public var dateFormat = "HH:mm:ss.SSS"
    public static var dateFormat: String {
        get {
            return sharedInstance.dateFormat
        }
        set {
            sharedInstance.dateFormat = newValue
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
    public var levelFlags = [EchoLevel.Trace: "💊", .Debug:  "☕️", .Info: "💡", .Warn: "⚠️", .Error: "❌", .Fatal: "💣", .Off: "😶"]
    public static var levelFlags: [EchoLevel: String] {
        get {
            return sharedInstance.levelFlags
        }
        set {
            sharedInstance.levelFlags = newValue
        }
    }


    public init() {
        
    }

    public func trace<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        log(value, .Trace, file, function, line)
    }
    public static func trace<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.log(value, .Trace, file, function, line)
    }
    public func debug<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        log(value, .Debug, file, function, line)
    }
    public static func debug<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.log(value, .Debug, file, function, line)
    }
    public func info<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        log(value, .Info, file, function, line)
    }
    public static func info<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.log(value, .Info, file, function, line)
    }
    public func warn<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        log(value, .Warn, file, function, line)
    }
    public static func warn<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.log(value, .Warn, file, function, line)
    }
    public func error<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        log(value, .Error, file, function, line)
    }
    public static func error<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.log(value, .Error, file, function, line)
    }
    public func fatal<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        log(value, .Fatal, file, function, line)
    }
    public static func fatal<T>(value: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.log(value, .Fatal, file, function, line)
    }

    private func log<T>(value: T, _ level: EchoLevel, _ file: StaticString, _ function: StaticString, _ line: UWord) {
        if level >= self.level {
            dateFormatter.dateFormat = dateFormat

            var log = format
            log = log.stringByReplacingOccurrencesOfString("\(EchoComponent.DateTime)", withString: dateFormatter.stringFromDate(NSDate()))
            log = log.stringByReplacingOccurrencesOfString("\(EchoComponent.Flag)", withString: levelFlags[level] ?? "\(level)")
            log = log.stringByReplacingOccurrencesOfString("\(EchoComponent.Filename)", withString: "\(file)".lastPathComponent)
            log = log.stringByReplacingOccurrencesOfString("\(EchoComponent.Function)", withString: "\(function)")
            log = log.stringByReplacingOccurrencesOfString("\(EchoComponent.Line)", withString: "\(line)")
            log = log.stringByReplacingOccurrencesOfString("\(EchoComponent.Message)", withString: "\(value)")
            println(log)
        }
    }

}
