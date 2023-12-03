//
//  LineReader.swift
//
//  Created by David Lindecrantz on 2023-12-01
//

import Darwin
import Foundation

public enum LineReaderError: Error {
    case bundleResourceNotFound
    case readAccessFailed
}

/// An object that provides efficient line by line access to a file.
public final class LineReader: Sequence {
    private static let initialBufferSize: Int = 512

    private let fp: UnsafeMutablePointer<FILE>
    private var size: Int
    private var buffer: UnsafeMutablePointer<Int8>?

    public init(_ path: String) throws {
        guard access(path, R_OK) == 0 else { throw LineReaderError.readAccessFailed }
        self.fp = fopen(path, "r")
        self.size = Self.initialBufferSize
        self.buffer = malloc(Self.initialBufferSize).initializeMemory(
            as: Int8.self, repeating: 0, count: Self.initialBufferSize
        )
    }

    public convenience init(_ resource: String, bundle: Bundle) throws  {
        guard let res = bundle.url(forResource: resource, withExtension: nil) else {
            throw LineReaderError.bundleResourceNotFound
        }
        try self.init(res.path())
    }

    deinit {
        buffer?.deinitialize(count: size)
        free(buffer)
    }

    public func next() -> String? {
        let len = getline(&buffer, &size, fp)
        if len == -1 { return nil }
        // Remove line break
        if len > 0, buffer![len - 1] == 0x0A {
            buffer![len - 1] = 0
        }
        if len > 1, buffer![len - 2] == 0x0D {
            buffer![len - 2] = 0
        }
        return String(cString: buffer!)
    }

    public func makeIterator() -> LineReaderIterator {
        return LineReaderIterator(self)
    }
}

public struct LineReaderIterator: IteratorProtocol, LazySequenceProtocol {
    private let reader: LineReader

    public init(_ reader: LineReader) {
        self.reader = reader
    }

    public func next() -> String? {
        reader.next()
    }
}
