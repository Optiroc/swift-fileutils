//
//  LineReaderTests.swift
//
//  Created by David Lindecrantz on 2023-12-01
//


import XCTest
@testable import FileUtils

struct Measure {
    private(set) var start = ProcessInfo.processInfo.systemUptime

    var elapsed: Double { ProcessInfo.processInfo.systemUptime - start }

    mutating func reset() { start = ProcessInfo.processInfo.systemUptime }
}

final class LineReaderTests: XCTestCase {
    func testLineBreaks() throws {
        let lfChars = try LineReader("Lorem_LF.txt", bundle: .module)
            .reduce(into: 0) { acc, line in acc += line.count }

        let crlfChars = try LineReader("Lorem_CRLF.txt", bundle: .module)
            .reduce(into: 0) { acc, line in acc += line.count }

        XCTAssert(828 == lfChars)
        XCTAssert(crlfChars == lfChars)
    }

    func testCountLines() throws {
        let apache2kLines = try LineReader("Apache_2k.log", bundle: .module)
            .reduce(into: 0) { acc, _ in acc += 1 }
        XCTAssert(2000 == apache2kLines)

        let apacheLines = try LineReader("Apache.log", bundle: .module)
            .reduce(into: 0) { acc, _ in acc += 1 }
        XCTAssert(56482 == apacheLines)

        let hpcLines = try LineReader("HPC.log", bundle: .module)
            .reduce(into: 0) { acc, _ in acc += 1 }
        XCTAssert(433490 == hpcLines)
    }

    func testEnumerateLines() throws {
        var lineCount = 0
        var charCount = 0
        for (index, line) in try LineReader("Apache.log", bundle: .module).enumerated() {
            assert(lineCount == index)
            lineCount += 1
            charCount += line.count
        }
        XCTAssert(56482 == lineCount)
        XCTAssert(5079395 == charCount)
    }

    func testPerformance() throws {
        let iterations = 10
        let measure = Measure()
        var totalLines = 0
        for _ in 1...iterations {
            let lines = try LineReader("HPC.log", bundle: .module)
                .reduce(into: 0) { acc, _ in acc += 1 }
            totalLines += lines
        }
        let time = measure.elapsed
        print("Iterations: \(iterations) - Lines: \(totalLines) - Total: \(time)s - Avg: \(time / Double(iterations))s")
    }
}
