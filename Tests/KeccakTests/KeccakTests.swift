import Foundation
import Keccak
import Testing

@Test
func `Keccak-p[1600, 24]`() {
    var state = Keccak1600<24>()

    state.permute()

    var expected: [UInt64] = [
        0xf125_8f79_40e1_dde7, 0x84d5_ccf9_33c0_478a, 0xd598_261e_a65a_a9ee, 0xbd15_4730_6f80_494d,
        0x8b28_4e05_6253_d057, 0xff97_a42d_7f8e_6fd4, 0x90fe_e5a0_a446_47c4, 0x8c5b_da0c_d619_2e76,
        0xad30_a6f7_1b19_059c, 0x3093_5ab7_d08f_fc64, 0xeb5a_a93f_2317_d635, 0xa9a6_e626_0d71_2103,
        0x81a5_7c16_dbcf_555f, 0x43b8_31cd_0347_c826, 0x01f2_2f1a_11a5_569f, 0x05e5_635a_21d9_ae61,
        0x64be_fef2_8cc9_70f2, 0x6136_7095_7bc4_6611, 0xb87c_5a55_4fd0_0ecb, 0x8c3e_e88a_1ccf_32c8,
        0x940c_7922_ae3a_2614, 0x1841_f924_a2c5_09e4, 0x16f5_3526_e704_65c2, 0x75f6_44e9_7f30_a13b,
        0xeaf1_ff7b_5cec_a249,
    ]

    #expect(state.lanes.elementsEqual(expected))

    state.permute()

    expected = [
        0x2d5c_954d_f96e_cb3c, 0x6a33_2cd0_7057_b56d, 0x093d_8d12_70d7_6b6c, 0x8a20_d9b2_5569_d094,
        0x4f9c_4f99_e5e7_f156, 0xf957_b9a2_da65_fb38, 0x8577_3dae_1275_af0d, 0xfaf4_f247_c3d8_10f7,
        0x1f1b_9ee6_f79a_8759, 0xe4fe_cc0f_ee98_b425, 0x68ce_61b6_b9ce_68a1, 0xdeea_66c4_ba8f_974f,
        0x33c4_3d83_6eaf_b1f5, 0xe006_5404_2719_dbd9, 0x7cf8_a9f0_0983_1265, 0xfd54_49a6_bf17_4743,
        0x97dd_ad33_d899_4b40, 0x48ea_d5fc_5d0b_e774, 0xe3b8_c8ee_55b7_b03c, 0x91a0_226e_649e_42e9,
        0x900e_3129_e7ba_dd7b, 0x202a_9ec5_faa3_cce8, 0x5b34_0246_4e1c_3db6, 0x609f_4e62_a44c_1059,
        0x20d0_6cd2_6a8f_bf5c,
    ]

    #expect(state.lanes.elementsEqual(expected))
}

@Test
func `Keccak-p[800, 24]`() {
    var state = Keccak800<24>()

    state.permute()

    var expected: [UInt32] = [
        0xd1be_8551, 0x44c0_cb95, 0x3850_fee7, 0x4e2c_7497, 0xde92_1892, 0xe58a_db02, 0x468f_e98b,
        0x910f_bd71, 0xcb99_c34f, 0xbf85_e015, 0x906a_9dfa, 0x5516_a41c, 0xd9a7_074e, 0x0fa4_5a31,
        0x18fa_cc8f, 0x126f_2299, 0xfeac_e886, 0xd8fd_2801, 0xaa42_e6b3, 0xf7bd_889d, 0x175d_6b40,
        0x1d3c_bb8b, 0x41ff_b5d2, 0x35cc_06a2, 0x3a8b_781e,
    ]

    #expect(state.lanes.elementsEqual(expected))

    state.permute()

    expected = [
        0x709d_8d5e, 0xeda0_7af9, 0xa577_5ff2, 0x22c8_5726, 0xe680_247e, 0x9538_1b61, 0xdbe0_39a8,
        0xb4a3_d982, 0x537f_3550, 0x5f42_ed19, 0x7f95_4b94, 0xb8da_0955, 0x11dd_a7d4, 0x09ae_10e5,
        0x654f_a9f0, 0x6170_8b30, 0xd224_f3e0, 0x8df4_c78a, 0x2335_e48f, 0xb48e_ab63, 0x8958_1e9a,
        0x782e_3e15, 0x85a5_ed55, 0xbcde_69f6, 0x40af_729b,
    ]

    #expect(state.lanes.elementsEqual(expected))
}

@Test
func `Keccak-p[400, 24]`() {
    var state = Keccak400<24>()

    state.permute()

    var expected: [UInt16] = [
        0xb8ec, 0x317a, 0xf6da, 0x8ca2, 0xcbf2, 0x2cb9, 0x5de3, 0xf999, 0x343a, 0xa7bc, 0x107c,
        0x65c8, 0x55a1, 0xf0a4, 0x7798, 0xae6f, 0xc6d5, 0x6ee6, 0x2884, 0xd81b, 0x7ead, 0x6d8d,
        0xcd1f, 0x4bf7, 0xd524,
    ]

    #expect(state.lanes.elementsEqual(expected))

    state.permute()

    expected = [
        0xa1ae, 0x1772, 0xdad7, 0x9294, 0x9f1f, 0x0d4c, 0x1cd3, 0x6345, 0x4011, 0x9c9d, 0x322d,
        0xe24a, 0x16f0, 0x2b37, 0xd46a, 0xa84d, 0x6e87, 0xc3a1, 0x3dc8, 0xa5d5, 0x3161, 0x2a44,
        0x6765, 0x5097, 0x39a6,
    ]

    #expect(state.lanes.elementsEqual(expected))
}

@Test
func `Keccak-p[200, 24]`() {
    var state = Keccak200<24>()

    state.permute()

    var expected: [UInt8] = [
        0xe6, 0x8a, 0x62, 0x98, 0x3e, 0x49, 0x5b, 0x57, 0x6b, 0x45, 0xba, 0x64, 0x64, 0x41, 0x29,
        0xde, 0xd0, 0x55, 0xd6, 0xea, 0x02, 0x2d, 0x32, 0xb6, 0x35,
    ]

    #expect(state.lanes.elementsEqual(expected))

    state.permute()

    expected = [
        0x97, 0x6c, 0xcd, 0x53, 0x9c, 0x94, 0x2c, 0x45, 0x01, 0xbf, 0xf5, 0xfc, 0x84, 0x12, 0xe9,
        0x97, 0xfe, 0x00, 0x94, 0x90, 0x94, 0x77, 0xaf, 0x40, 0xaf,
    ]

    #expect(state.lanes.elementsEqual(expected))
}

extension InlineArray where Element: Equatable {
    fileprivate func elementsEqual(_ other: some Sequence<Element>) -> Bool {
        var iterator = other.makeIterator()

        for index in indices {
            guard
                let otherElement = iterator.next(),
                self[index] == otherElement
            else {
                return false
            }
        }

        return iterator.next() == nil
    }
}
