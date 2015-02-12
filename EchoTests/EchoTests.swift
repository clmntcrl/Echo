//  Echo by Clément Cyril - @clmntcrl - http://clmntcrl.io/
//  Copyright 2014 Clément Cyril. See LICENSE.

import XCTest

class EchoTests: XCTestCase {

    // MARK: Test Echo levels

    func testEchoLevelOff() {
        var echo = Echo()
        echo.level = .Off

        XCTAssertNil(echo.trace("Trace"), "Fail: Echo reflect .Trace with level set to .Off")
        XCTAssertNil(echo.debug("Debug"), "Fail: Echo reflect .Debug with level set to .Off")
        XCTAssertNil(echo.info("Info"), "Fail: Echo reflect .Info with level set to .Off")
        XCTAssertNil(echo.warn("Warn"), "Fail: Echo reflect .Warn with level set to .Off")
        XCTAssertNil(echo.error("Error"), "Fail: Echo reflect .Error with level set to .Off")
        XCTAssertNil(echo.error("Fatal"), "Fail: Echo reflect .Fatal with level set to .Off")
    }
    func testEchoLevelInfo() {
        var echo = Echo()
        echo.level = .Info

        XCTAssertNil(echo.trace("Trace"), "Fail: Echo reflect .Trace with level set to .Info")
        XCTAssertNil(echo.debug("Debug"), "Fail: Echo reflect .Debug with level set to .Info")
        XCTAssertNotNil(echo.info("Info"), "Fail: Echo don't reflect .Info with level set to .Info")
        XCTAssertNotNil(echo.warn("Warn"), "Fail: Echo don't reflect .Warn with level set to .Info")
        XCTAssertNotNil(echo.error("Error"), "Fail: Echo don't reflect .Error with level set to .Info")
        XCTAssertNotNil(echo.error("Fatal"), "Fail: Echo don't reflect .Fatal with level set to .Info")
    }
    
    // MARK: Test Echo selective code execution
    
    func testEchoSelectiveCodeExecution() {
        var echo = Echo()
        echo.level = .Trace

        XCTAssertNotNil(echo.trace({ () -> Bool in return true }), "Fail:")
    }

    // MARK: Test Echo formats

    func testEchoFormat() {
        var echo = Echo()
        echo.level = .Trace
        echo.format = [
            .Flag(flags: [.Fatal: "❗️💀⚡️💣💥"]),
            .Separator(" "),
            .Filename,
            .Separator("—"),
            .Function,
            .Separator(":"),
            .Line,
            .Separator("| "),
            .Message
        ]
        var f = String(__FILE__).lastPathComponent, fn = __FUNCTION__, l = __LINE__, m = "Just test my awesome Echo format.", r1 = echo.fatal(m), r2 = echo.trace(m)

        XCTAssertEqual(r1!, "❗️💀⚡️💣💥 \(f)—\(fn):\(l)| \(m)", "Fail: Echo don't apply custom format")
        XCTAssertEqual(r2!, " \(f)—\(fn):\(l)| \(m)", "Fail: Echo don't apply custom format")
    }

    // MARK: Test Echo output

    func testEchoOutput() {
        var output: String = ""

        var echo = Echo()
        echo.level = .Trace
        echo.format = [
            .Flag(flags: [.Trace: "TRACE", .Debug:  "DEBUG", .Info: "INFO", .Warn: "WARN", .Error: "ERROR", .Fatal: "FATAL"]),
            .Message
        ]
        echo.reflect = { output += $0 }

        XCTAssertEqual(echo.trace("test my awesome Echo new output.")!, output, "Fail: Echo don't reflect on the custom output")
    }
}
