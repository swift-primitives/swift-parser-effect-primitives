# Parser Effect Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)
[![CI](https://github.com/swift-primitives/swift-parser-effect-primitives/actions/workflows/ci.yml/badge.svg)](https://github.com/swift-primitives/swift-parser-effect-primitives/actions/workflows/ci.yml)

Parser backtracking as a first-class effect — `Parser.Backtrack` reifies non-deterministic choice as a value, so the restore-and-retry policy lives in one handler instead of being hand-rolled inside every choice combinator.

This is the seed package of the effectful-parsing domain, and it is deliberately small: one effect type. `Parser.Backtrack` carries its parser alternatives as data and conforms to the effect protocol from `swift-effect-primitives`; deciding *how* the alternatives are explored — first match wins, every match of an ambiguous grammar collected, backtracking counted for profiling — is a handler concern, written once against `Effect.Handler.Protocol`. The package defines the effect vocabulary; it does not yet ship built-in handlers or an integration into the existing choice combinators.

---

## Quick Start

Manual backtracking duplicates the same fragile dance at every choice site — save a checkpoint, try, seek back, try the next:

```swift
// Baseline — every choice combinator repeats this by hand:
let saved = input.checkpoint
do {
    return try keyword.parse(&input)
} catch {
    input.seek(to: saved)   // forget this line and the parse is silently wrong
    return try identifier.parse(&input)
}
```

With the effect, the choice itself is a value. The alternatives travel with it, and no restore logic appears at the call site:

```swift
import Parser_Backtrack_Primitives

enum Sign: Swift.Error { case missing }
typealias Bytes = Input.Buffer<ContiguousArray<UInt8>>

let sign = Parser.Backtrack<Bytes, Int, Sign>(
    first: { input in
        guard input.first == 0x2B /* "+" */ else { throw Sign.missing }
        return 1
    },
    second: { _ in -1 }
)

// The effect is plain data — inspectable before any handler runs:
sign.alternatives.count  // 2
```

A handler interprets the effect: conforming to `Effect.Handler.Protocol` (from `swift-effect-primitives`), a first-match handler restores the input from a checkpoint and resumes its `Effect.Continuation.One` with the first alternative that parses; a multi-shot handler uses `Effect.Continuation.Multi` to yield every successful parse of an ambiguous grammar. The same effect value serves both without change.

---

## Installation

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-parser-effect-primitives.git", branch: "main")
]
```

Add the product to your target:

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Parser Backtrack Primitives", package: "swift-parser-effect-primitives")
    ]
)
```

The package is pre-1.0 — depend on `branch: "main"` until `0.1.0` is tagged. Requires Swift 6.3 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the corresponding Linux / Windows toolchain).

---

## Architecture

| Product | Contents | When to import |
|---------|----------|----------------|
| `Parser Backtrack Primitives` | `Parser.Backtrack`, plus the re-exported parser core (`Parser.Protocol`, the `Input` cursor vocabulary) | Any consumer of the effect |
| `Parser Backtrack Primitives Test Support` | Test-support seam for downstream suites (currently scaffolding only) | Not yet — reserved for future test utilities |

Importing `Parser_Backtrack_Primitives` brings the parser core along, so a consumer needs no separate parser-primitives import to write alternatives.

---

## Related Packages

- [`swift-effect-primitives`](https://github.com/swift-primitives/swift-effect-primitives) — the effect system (`Effect.Protocol`, handlers, one-shot and multi-shot continuations) the backtrack effect plugs into.
- [`swift-parser-primitives`](https://github.com/swift-primitives/swift-parser-primitives) — the parser vocabulary (`Parser.Protocol`, combinators) whose core this package re-exports.
- [`swift-input-primitives`](https://github.com/swift-primitives/swift-input-primitives) — the input cursors (`Input.Buffer`, checkpoints, `seek`) that parser alternatives advance and restore.

---

## Community

<!-- BEGIN: discussion -->
*Discussion thread will be created at first public release.*
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
