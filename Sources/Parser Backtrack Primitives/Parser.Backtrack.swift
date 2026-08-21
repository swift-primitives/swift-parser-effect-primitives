public import Effect_Primitives

extension Parser {

    public struct Backtrack<
        Input: Input_Primitives.Input.`Protocol`,
        Output: Sendable,
        E: Swift.Error
    >: Effect.`Protocol` {

        public let alternatives: [Alternative]

        @inlinable
        public init(alternatives: [Alternative]) {
            self.alternatives = alternatives
        }

        @inlinable
        public init(
            first: @escaping Alternative,
            second: @escaping Alternative
        ) {
            self.alternatives = [first, second]
        }
    }
}

extension Parser.Backtrack {

    public typealias Alternative = (inout Input) throws(E) -> Output

    public typealias Arguments = [Alternative]

    public typealias Value = Output

    public typealias Failure = E

    public var arguments: [Alternative] { alternatives }
}
