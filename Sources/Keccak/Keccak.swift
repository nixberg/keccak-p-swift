public typealias Keccak200<let rounds: Int> = Keccak<UInt8, rounds>

public typealias Keccak400<let rounds: Int> = Keccak<UInt16, rounds>

public typealias Keccak800<let rounds: Int> = Keccak<UInt32, rounds>

public typealias Keccak1600<let rounds: Int> = Keccak<UInt64, rounds>

public struct Keccak<Lane, let rounds: Int>: ~Copyable
where Lane: FixedWidthInteger & UnsignedInteger {
    public var lanes: InlineArray<25, Lane>

    public init() {
        self.init(lanes: InlineArray(repeating: 0))
    }

    public init(lanes: InlineArray<25, Lane>) {
        precondition(
            [8, 16, 32, 64].contains(Lane.bitWidth),
            "Generic parameter `Lane` has invalid bit width"
        )
        precondition(
            stride(from: 12, through: 24, by: 2).contains(rounds),
            "Generic parameter `rounds` must be an even number from 12 through 24"
        )
        self.lanes = lanes
    }

    public mutating func permute() {
        var round = 24 - rounds
        while round < 24 {
            self.theta()
            self.rhoAndPi()
            self.chi()
            self.iota(round)
            round &+= 1
        }
    }

    private mutating func theta() {
        let c: InlineArray<5, Lane> = [
            lanes[00] ^ lanes[05] ^ lanes[10] ^ lanes[15] ^ lanes[20],
            lanes[01] ^ lanes[06] ^ lanes[11] ^ lanes[16] ^ lanes[21],
            lanes[02] ^ lanes[07] ^ lanes[12] ^ lanes[17] ^ lanes[22],
            lanes[03] ^ lanes[08] ^ lanes[13] ^ lanes[18] ^ lanes[23],
            lanes[04] ^ lanes[09] ^ lanes[14] ^ lanes[19] ^ lanes[24],
        ]

        let d: InlineArray<5, Lane> = [
            c[4] ^ c[1].rotated(left: 1),
            c[0] ^ c[2].rotated(left: 1),
            c[1] ^ c[3].rotated(left: 1),
            c[2] ^ c[4].rotated(left: 1),
            c[3] ^ c[0].rotated(left: 1),
        ]

        lanes[00] ^= d[0]
        lanes[05] ^= d[0]
        lanes[10] ^= d[0]
        lanes[15] ^= d[0]
        lanes[20] ^= d[0]

        lanes[01] ^= d[1]
        lanes[06] ^= d[1]
        lanes[11] ^= d[1]
        lanes[16] ^= d[1]
        lanes[21] ^= d[1]

        lanes[02] ^= d[2]
        lanes[07] ^= d[2]
        lanes[12] ^= d[2]
        lanes[17] ^= d[2]
        lanes[22] ^= d[2]

        lanes[03] ^= d[3]
        lanes[08] ^= d[3]
        lanes[13] ^= d[3]
        lanes[18] ^= d[3]
        lanes[23] ^= d[3]

        lanes[04] ^= d[4]
        lanes[09] ^= d[4]
        lanes[14] ^= d[4]
        lanes[19] ^= d[4]
        lanes[24] ^= d[4]
    }

    private mutating func rhoAndPi() {
        var current = lanes[01]
        current = exchange(&lanes[10], with: current.rotated(left: 01))
        current = exchange(&lanes[07], with: current.rotated(left: 03))
        current = exchange(&lanes[11], with: current.rotated(left: 06))
        current = exchange(&lanes[17], with: current.rotated(left: 10))
        current = exchange(&lanes[18], with: current.rotated(left: 15))
        current = exchange(&lanes[03], with: current.rotated(left: 21))
        current = exchange(&lanes[05], with: current.rotated(left: 28))
        current = exchange(&lanes[16], with: current.rotated(left: 36))
        current = exchange(&lanes[08], with: current.rotated(left: 45))
        current = exchange(&lanes[21], with: current.rotated(left: 55))
        current = exchange(&lanes[24], with: current.rotated(left: 02))
        current = exchange(&lanes[04], with: current.rotated(left: 14))
        current = exchange(&lanes[15], with: current.rotated(left: 27))
        current = exchange(&lanes[23], with: current.rotated(left: 41))
        current = exchange(&lanes[19], with: current.rotated(left: 56))
        current = exchange(&lanes[13], with: current.rotated(left: 08))
        current = exchange(&lanes[12], with: current.rotated(left: 25))
        current = exchange(&lanes[02], with: current.rotated(left: 43))
        current = exchange(&lanes[20], with: current.rotated(left: 62))
        current = exchange(&lanes[14], with: current.rotated(left: 18))
        current = exchange(&lanes[22], with: current.rotated(left: 39))
        current = exchange(&lanes[09], with: current.rotated(left: 61))
        current = exchange(&lanes[06], with: current.rotated(left: 20))
        current = exchange(&lanes[01], with: current.rotated(left: 44))
    }

    private mutating func chi() {
        var temps: InlineArray<2, Lane>

        temps = [lanes[00], lanes[01]]
        lanes[00] ^= ~lanes[01] & lanes[02]
        lanes[01] ^= ~lanes[02] & lanes[03]
        lanes[02] ^= ~lanes[03] & lanes[04]
        lanes[03] ^= ~lanes[04] & temps[00]
        lanes[04] ^= ~temps[00] & temps[01]

        temps = [lanes[05], lanes[06]]
        lanes[05] ^= ~lanes[06] & lanes[07]
        lanes[06] ^= ~lanes[07] & lanes[08]
        lanes[07] ^= ~lanes[08] & lanes[09]
        lanes[08] ^= ~lanes[09] & temps[00]
        lanes[09] ^= ~temps[00] & temps[01]

        temps = [lanes[10], lanes[11]]
        lanes[10] ^= ~lanes[11] & lanes[12]
        lanes[11] ^= ~lanes[12] & lanes[13]
        lanes[12] ^= ~lanes[13] & lanes[14]
        lanes[13] ^= ~lanes[14] & temps[00]
        lanes[14] ^= ~temps[00] & temps[01]

        temps = [lanes[15], lanes[16]]
        lanes[15] ^= ~lanes[16] & lanes[17]
        lanes[16] ^= ~lanes[17] & lanes[18]
        lanes[17] ^= ~lanes[18] & lanes[19]
        lanes[18] ^= ~lanes[19] & temps[00]
        lanes[19] ^= ~temps[00] & temps[01]

        temps = [lanes[20], lanes[21]]
        lanes[20] ^= ~lanes[21] & lanes[22]
        lanes[21] ^= ~lanes[22] & lanes[23]
        lanes[22] ^= ~lanes[23] & lanes[24]
        lanes[23] ^= ~lanes[24] & temps[00]
        lanes[24] ^= ~temps[00] & temps[01]
    }

    private mutating func iota(_ round: Int) {
        let roundConstants: InlineArray<24, Lane> = [
            Lane(truncatingIfNeeded: 0x0000_0000_0000_0001 as UInt64),
            Lane(truncatingIfNeeded: 0x0000_0000_0000_8082 as UInt64),
            Lane(truncatingIfNeeded: 0x8000_0000_0000_808a as UInt64),
            Lane(truncatingIfNeeded: 0x8000_0000_8000_8000 as UInt64),
            Lane(truncatingIfNeeded: 0x0000_0000_0000_808b as UInt64),
            Lane(truncatingIfNeeded: 0x0000_0000_8000_0001 as UInt64),
            Lane(truncatingIfNeeded: 0x8000_0000_8000_8081 as UInt64),
            Lane(truncatingIfNeeded: 0x8000_0000_0000_8009 as UInt64),
            Lane(truncatingIfNeeded: 0x0000_0000_0000_008a as UInt64),
            Lane(truncatingIfNeeded: 0x0000_0000_0000_0088 as UInt64),
            Lane(truncatingIfNeeded: 0x0000_0000_8000_8009 as UInt64),
            Lane(truncatingIfNeeded: 0x0000_0000_8000_000a as UInt64),
            Lane(truncatingIfNeeded: 0x0000_0000_8000_808b as UInt64),
            Lane(truncatingIfNeeded: 0x8000_0000_0000_008b as UInt64),
            Lane(truncatingIfNeeded: 0x8000_0000_0000_8089 as UInt64),
            Lane(truncatingIfNeeded: 0x8000_0000_0000_8003 as UInt64),
            Lane(truncatingIfNeeded: 0x8000_0000_0000_8002 as UInt64),
            Lane(truncatingIfNeeded: 0x8000_0000_0000_0080 as UInt64),
            Lane(truncatingIfNeeded: 0x0000_0000_0000_800a as UInt64),
            Lane(truncatingIfNeeded: 0x8000_0000_8000_000a as UInt64),
            Lane(truncatingIfNeeded: 0x8000_0000_8000_8081 as UInt64),
            Lane(truncatingIfNeeded: 0x8000_0000_0000_8080 as UInt64),
            Lane(truncatingIfNeeded: 0x0000_0000_8000_0001 as UInt64),
            Lane(truncatingIfNeeded: 0x8000_0000_8000_8008 as UInt64),
        ]
        lanes[0] ^= unsafe roundConstants[unchecked: round]
    }
}

extension FixedWidthInteger where Self: UnsignedInteger {
    fileprivate func rotated(left count: Int) -> Self {
        self &<< count | self &>> (Self.bitWidth &- count)
    }
}
