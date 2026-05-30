import Parser_Backtrack_Primitives
import Parser_Primitives_Test_Support
import Testing

@Suite("Parser.Backtrack Tests")
struct ParserBacktrackTests {
    @Suite struct Unit {}
}

extension ParserBacktrackTests.Unit {
    /// A trivial error type for exercising the effect's `Failure` parameter.
    enum TestError: Swift.Error {
        case noAlternativeMatched
    }

    private typealias Backtrack = Parser.Backtrack<Parser.Test.Input, Int, TestError>

    @Test
    func `init(first:second:) stores two alternatives`() {
        let effect = Backtrack(
            first: { _ in 1 },
            second: { _ in 2 }
        )
        #expect(effect.alternatives.count == 2)
    }

    @Test
    func `init(alternatives:) stores all alternatives`() {
        let effect = Backtrack(
            alternatives: [
                { _ in 10 },
                { _ in 20 },
                { _ in 30 },
            ]
        )
        #expect(effect.alternatives.count == 3)
    }

    @Test
    func `arguments mirrors alternatives`() {
        let effect = Backtrack(
            first: { _ in 1 },
            second: { _ in 2 }
        )
        #expect(effect.arguments.count == effect.alternatives.count)
    }

    @Test
    func `stored alternatives produce expected outputs`() throws(TestError) {
        let effect = Backtrack(
            first: { _ in 7 },
            second: { _ in 9 }
        )
        var input = Parser.Test.Input(utf8: "abc")
        let first = try effect.alternatives[0](&input)
        let second = try effect.alternatives[1](&input)
        #expect(first == 7)
        #expect(second == 9)
    }

    @Test
    func `empty alternatives is permitted`() {
        let effect = Backtrack(alternatives: [])
        #expect(effect.alternatives.isEmpty)
    }
}
