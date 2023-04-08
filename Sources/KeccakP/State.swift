public struct State {
    private var rows: (Row, Row, Row, Row, Row)
    
    public init() {
        rows = (.zero, .zero, .zero, .zero, .zero)
    }
    
    public mutating func permute(rounds: Int) {
        precondition(stride(from: 12, through: 24, by: 2).contains(rounds))
        
        for constant: UInt64 in [
            0x0000000000000001, 0x0000000000008082, 0x800000000000808a, 0x8000000080008000,
            0x000000000000808b, 0x0000000080000001, 0x8000000080008081, 0x8000000000008009,
            0x000000000000008a, 0x0000000000000088, 0x0000000080008009, 0x000000008000000a,
            0x000000008000808b, 0x800000000000008b, 0x8000000000008089, 0x8000000000008003,
            0x8000000000008002, 0x8000000000000080, 0x000000000000800a, 0x800000008000000a,
            0x8000000080008081, 0x8000000000008080, 0x0000000080000001, 0x8000000080008008,
        ].suffix(rounds) {
            self.theta()
            
            self.rhoAndPi()
            
            self.chi()
            
            rows.0.lanes.0 ^= constant
        }
    }
    
    @inline(__always)
    private mutating func theta() {
        var c = rows.0
        
        c ^= rows.1
        c ^= rows.2
        c ^= rows.3
        c ^= rows.4
        
        let d = c.theta()
        
        rows.0 ^= d
        rows.1 ^= d
        rows.2 ^= d
        rows.3 ^= d
        rows.4 ^= d
    }
    
    @inline(__always)
    private mutating func rhoAndPi() {
        var lane = rows.0.lanes.1
        rows.2.lanes.0.swap(with: &lane, rotatedLeft:  1)
        rows.1.lanes.2.swap(with: &lane, rotatedLeft:  3)
        rows.2.lanes.1.swap(with: &lane, rotatedLeft:  6)
        rows.3.lanes.2.swap(with: &lane, rotatedLeft: 10)
        rows.3.lanes.3.swap(with: &lane, rotatedLeft: 15)
        rows.0.lanes.3.swap(with: &lane, rotatedLeft: 21)
        rows.1.lanes.0.swap(with: &lane, rotatedLeft: 28)
        rows.3.lanes.1.swap(with: &lane, rotatedLeft: 36)
        rows.1.lanes.3.swap(with: &lane, rotatedLeft: 45)
        rows.4.lanes.1.swap(with: &lane, rotatedLeft: 55)
        rows.4.lanes.4.swap(with: &lane, rotatedLeft:  2)
        rows.0.lanes.4.swap(with: &lane, rotatedLeft: 14)
        rows.3.lanes.0.swap(with: &lane, rotatedLeft: 27)
        rows.4.lanes.3.swap(with: &lane, rotatedLeft: 41)
        rows.3.lanes.4.swap(with: &lane, rotatedLeft: 56)
        rows.2.lanes.3.swap(with: &lane, rotatedLeft:  8)
        rows.2.lanes.2.swap(with: &lane, rotatedLeft: 25)
        rows.0.lanes.2.swap(with: &lane, rotatedLeft: 43)
        rows.4.lanes.0.swap(with: &lane, rotatedLeft: 62)
        rows.2.lanes.4.swap(with: &lane, rotatedLeft: 18)
        rows.4.lanes.2.swap(with: &lane, rotatedLeft: 39)
        rows.1.lanes.4.swap(with: &lane, rotatedLeft: 61)
        rows.1.lanes.1.swap(with: &lane, rotatedLeft: 20)
        rows.0.lanes.1.swap(with: &lane, rotatedLeft: 44)
    }
    
    @inline(__always)
    private mutating func chi() {
        rows.0.chi()
        rows.1.chi()
        rows.2.chi()
        rows.3.chi()
        rows.4.chi()
    }
}

private struct Row {
    static let zero = Self(lanes: (0, 0, 0, 0, 0))
    
    var lanes: (UInt64, UInt64, UInt64, UInt64, UInt64)
    
    @inline(__always)
    static func ^= (lhs: inout Self, rhs: Self) {
        lhs.lanes.0 ^= rhs.lanes.0
        lhs.lanes.1 ^= rhs.lanes.1
        lhs.lanes.2 ^= rhs.lanes.2
        lhs.lanes.3 ^= rhs.lanes.3
        lhs.lanes.4 ^= rhs.lanes.4
    }
    
    @inline(__always)
    func theta() -> Self {
        Self(lanes: (
            lanes.4 ^ lanes.1.rotated(left: 1),
            lanes.0 ^ lanes.2.rotated(left: 1),
            lanes.1 ^ lanes.3.rotated(left: 1),
            lanes.2 ^ lanes.4.rotated(left: 1),
            lanes.3 ^ lanes.0.rotated(left: 1)
        ))
    }
    
    @inline(__always)
    mutating func chi() {
        let t = self
        lanes.0 ^= ~t.lanes.1 & t.lanes.2
        lanes.1 ^= ~t.lanes.2 & t.lanes.3
        lanes.2 ^= ~t.lanes.3 & t.lanes.4
        lanes.3 ^= ~t.lanes.4 & t.lanes.0
        lanes.4 ^= ~t.lanes.0 & t.lanes.1
    }
}

private extension UInt64 {
    @inline(__always)
    func rotated(left count: Int) -> Self {
        (self &<< count) | (self &>> (Self.bitWidth - count))
    }
    
    @inline(__always)
    mutating func swap(with lane: inout Self, rotatedLeft count: Int) {
        let temp = self
        self = lane.rotated(left: count)
        lane = temp
    }
}

#if _endian(big)
#error("Big-endian platforms are currently not supported")
#endif
