//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2020 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

@_implementationOnly import FoundationICU

enum ICU { }

internal struct ICUError: Error, CustomDebugStringConvertible {
    var code: UErrorCode
    init(code: UErrorCode) {
        self.code = code
    }

    var debugDescription: String {
        String(utf8String: u_errorName(code)) ?? "Unknown ICU error \(code.rawValue)"
    }
}

extension UErrorCode {
    func checkSuccess() throws {
        if !isSuccess {
            throw ICUError(code: self)
        }
    }

    var isSuccess: Bool {
        self.rawValue <= U_ZERO_ERROR.rawValue
    }
}

/// Allocate a buffer with 32 UChars and execute the given block. If a larger
/// buffer is needed, the closure may return `retry: true` alongside with the
/// size for a larger buffer, and the block will be executed one more time.
internal func _withUCharBuffer(_ body: (UnsafeMutablePointer<UChar>, _ size: Int32) -> (retry: Bool, newCapacity: Int32?)) {
    var retry = false
    var capacity: Int32?

    withUnsafeTemporaryAllocation(of: UChar.self, capacity: 32) {
        buffer in
        (retry, capacity) = body(buffer.baseAddress!, 32)
    }

    if retry, let capacity = capacity {
        withUnsafeTemporaryAllocation(of: UChar.self, capacity: Int(capacity)) {
            buffer in
            buffer.assign(repeating: 0)
            if let baseAddress = buffer.baseAddress {
                _ = body(baseAddress, capacity)
            }
        }
    }
}
