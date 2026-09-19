import Bifunctor_Macro
import Testing
@Bifunctor private enum Choice<A, B> { case left([A?]); case right([B]); case empty }
extension Choice: Equatable where A: Equatable, B: Equatable {}
@Test func nestedSumBimapActionsCommute() {
    let values: [Choice<Int, Int>] = [.left([1, nil, 2]), .right([3, 4]), .empty]
    for value in values {
        #expect(value.bimap({ $0 }, { $0 }) == value)
        #expect(value.bimap({ $0 + 1 }, { $0 }).bimap({ $0 }, { $0 * 2 }) == value.bimap({ $0 + 1 }, { $0 * 2 }))
    }
}
