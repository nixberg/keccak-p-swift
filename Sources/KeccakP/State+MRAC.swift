extension State: MutableCollection & RandomAccessCollection {
    public var startIndex: Int {
        0
    }
    
    public var endIndex: Int {
        200
    }
    
    public subscript(index: Int) -> UInt8 {
        get {
            precondition(indices.contains(index), "Index out of range")
            return self.withUnsafeBufferPointer {
                $0[index]
            }
        }
        set {
            precondition(indices.contains(index), "Index out of range")
            self.withUnsafeMutableBufferPointer {
                $0[index] = newValue
            }
        }
    }
    
    public func withContiguousStorageIfAvailable<R>(
        _ body: (UnsafeBufferPointer<Element>) throws -> R
    ) rethrows -> R? {
        try self.withUnsafeBufferPointer(body)
    }
    
    public mutating func withContiguousMutableStorageIfAvailable<R>(
        _ body: (inout UnsafeMutableBufferPointer<Element>) throws -> R
    ) rethrows -> R? {
        try self.withUnsafeMutableBufferPointer { bufferPointer in
            var inoutBufferPointer = bufferPointer
            defer {
                precondition(
                    inoutBufferPointer == bufferPointer,
                    "\(Self.self) \(#function): replacing the buffer is not allowed"
                )
            }
            return try body(&inoutBufferPointer)
        }
    }
}

extension State {
    public func withUnsafeBufferPointer<R>(
        _ body: (UnsafeBufferPointer<Element>) throws -> R
    ) rethrows -> R {
        try self.withUnsafeBytes {
            try $0.withMemoryRebound(to: UInt8.self, body)
        }
    }
    
    public mutating func withUnsafeMutableBufferPointer<R>(
        _ body: (UnsafeMutableBufferPointer<Element>) throws -> R
    ) rethrows -> R {
        try self.withUnsafeMutableBytes {
            try $0.withMemoryRebound(to: UInt8.self, body)
        }
    }
    
    public func withUnsafeBytes<R>(
        _ body: (UnsafeRawBufferPointer) throws -> R
    ) rethrows -> R {
        try Swift.withUnsafeBytes(of: rows, body)
    }
    
    public mutating func withUnsafeMutableBytes<R>(
        _ body: (UnsafeMutableRawBufferPointer) throws -> R
    ) rethrows -> R {
        try Swift.withUnsafeMutableBytes(of: &rows, body)
    }
}

extension UnsafeMutableBufferPointer {
    fileprivate static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.baseAddress == rhs.baseAddress && lhs.count == rhs.count
    }
}
