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

    public func trace<T>(message: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        log(message, .Trace, file, function, line)
    }
    public static func trace<T>(message: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.log(message, .Trace, file, function, line)
    }
    public func debug<T>(message: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        log(message, .Debug, file, function, line)
    }
    public static func debug<T>(message: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.log(message, .Debug, file, function, line)
    }
    public func info<T>(message: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        log(message, .Info, file, function, line)
    }
    public static func info<T>(message: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.log(message, .Info, file, function, line)
    }
    public func warn<T>(message: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        log(message, .Warn, file, function, line)
    }
    public static func warn<T>(message: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.log(message, .Warn, file, function, line)
    }
    public func error<T>(message: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        log(message, .Error, file, function, line)
    }
    public static func error<T>(message: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.log(message, .Error, file, function, line)
    }
    public func fatal<T>(message: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        log(message, .Fatal, file, function, line)
    }
    public static func fatal<T>(message: T, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
        sharedInstance.log(message, .Fatal, file, function, line)
    }

    private func log<T>(message: T, _ level: EchoLevel, _ file: StaticString, _ function: StaticString, _ line: UWord) {
        if level >= self.level {
            dateFormatter.dateFormat = dateFormat

            var msg = format
            msg = msg.stringByReplacingOccurrencesOfString("\(EchoComponent.DateTime)", withString: dateFormatter.stringFromDate(NSDate()))
            msg = msg.stringByReplacingOccurrencesOfString("\(EchoComponent.Flag)", withString: levelFlags[level] ?? "\(level)")
            msg = msg.stringByReplacingOccurrencesOfString("\(EchoComponent.Filename)", withString: "\(file)".lastPathComponent)
            msg = msg.stringByReplacingOccurrencesOfString("\(EchoComponent.Function)", withString: "\(function)")
            msg = msg.stringByReplacingOccurrencesOfString("\(EchoComponent.Line)", withString: "\(line)")
            msg = msg.stringByReplacingOccurrencesOfString("\(EchoComponent.Message)", withString: "\(message)")
            println(msg)
        }
    }

}
