private typealias Row = (UInt64, UInt64, UInt64, UInt64, UInt64)

public struct Keccak {
    private var state: (Row, Row, Row, Row, Row) = (
        (0, 0, 0, 0, 0),
        (0, 0, 0, 0, 0),
        (0, 0, 0, 0, 0),
        (0, 0, 0, 0, 0),
        (0, 0, 0, 0, 0)
    )
    
    public init() {}
    
    public mutating func permute(rounds: Int) {
        assert(stride(from: 12, through: 24, by: 2).contains(rounds))
        for constant: UInt64 in [
            0x0000000000000001, 0x0000000000008082, 0x800000000000808a, 0x8000000080008000,
            0x000000000000808b, 0x0000000080000001, 0x8000000080008081, 0x8000000000008009,
            0x000000000000008a, 0x0000000000000088, 0x0000000080008009, 0x000000008000000a,
            0x000000008000808b, 0x800000000000008b, 0x8000000000008089, 0x8000000000008003,
            0x8000000000008002, 0x8000000000000080, 0x000000000000800a, 0x800000008000000a,
            0x8000000080008081, 0x8000000000008080, 0x0000000080000001, 0x8000000080008008,
        ].suffix(rounds) {
            self.round(withConstant: constant)
        }
    }
    
    @inline(__always)
    private mutating func round(withConstant constant: UInt64) {
        self.theta()
        self.rhoAndPi()
        self.chi()
        state.0.0 ^= constant
    }
    
    @inline(__always)
    private mutating func theta() {
        var c = state.0
        
        @inline(__always)
        func f(_ row: Row) {
            c.0 ^= row.0
            c.1 ^= row.1
            c.2 ^= row.2
            c.3 ^= row.3
            c.4 ^= row.4
        }
        f(state.1)
        f(state.2)
        f(state.3)
        f(state.4)
        
        let d = (
            c.4 ^ c.1.rotated(left: 1),
            c.0 ^ c.2.rotated(left: 1),
            c.1 ^ c.3.rotated(left: 1),
            c.2 ^ c.4.rotated(left: 1),
            c.3 ^ c.0.rotated(left: 1)
        )
        
        @inline(__always)
        func g(_ row: inout Row) {
            row.0 ^= d.0
            row.1 ^= d.1
            row.2 ^= d.2
            row.3 ^= d.3
            row.4 ^= d.4
        }
        g(&state.0)
        g(&state.1)
        g(&state.2)
        g(&state.3)
        g(&state.4)
    }
    
    @inline(__always)
    private mutating func rhoAndPi() {
        var currentWord = state.0.1
        
        @inline(__always)
        func f(_ word: inout UInt64, _ count: Int) {
            let temp = word
            word = currentWord.rotated(left: count)
            currentWord = temp
        }
        f(&state.2.0,  1)
        f(&state.1.2,  3)
        f(&state.2.1,  6)
        f(&state.3.2, 10)
        f(&state.3.3, 15)
        f(&state.0.3, 21)
        f(&state.1.0, 28)
        f(&state.3.1, 36)
        f(&state.1.3, 45)
        f(&state.4.1, 55)
        f(&state.4.4,  2)
        f(&state.0.4, 14)
        f(&state.3.0, 27)
        f(&state.4.3, 41)
        f(&state.3.4, 56)
        f(&state.2.3,  8)
        f(&state.2.2, 25)
        f(&state.0.2, 43)
        f(&state.4.0, 62)
        f(&state.2.4, 18)
        f(&state.4.2, 39)
        f(&state.1.4, 61)
        f(&state.1.1, 20)
        f(&state.0.1, 44)
    }
    
    @inline(__always)
    private mutating func chi() {
        @inline(__always)
        func f(_ row: inout Row) {
            let t = row
            row.0 ^= ~t.1 & t.2
            row.1 ^= ~t.2 & t.3
            row.2 ^= ~t.3 & t.4
            row.3 ^= ~t.4 & t.0
            row.4 ^= ~t.0 & t.1
        }
        f(&state.0)
        f(&state.1)
        f(&state.2)
        f(&state.3)
        f(&state.4)
    }
}

private extension UInt64 {
    @inline(__always)
    func rotated(left count: Int) -> Self {
        (self &<< count) | (self &>> (Self.bitWidth - count))
    }
}

#if _endian(big)
#error("Big-endian platforms are currently not supported")
#endif
