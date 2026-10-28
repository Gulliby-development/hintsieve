import Testing
@testable import HintSieveCore

@Suite struct RankingTests {
  enum Lists {
    static let fiveWords = ["crane", "slate", "trace", "crate", "grace", "brace", "stone"]
  }

  @Test func ordersByWorstThenSquares() {
    #expect(
      Ranking.rank(pool: ["crane", "slate", "trace"], candidates: ["crane", "slate", "trace", "grace"]) == [
        RankRow(word: "trace", worst: 1, parts: 4, squares: 4, isCandidate: true),
        RankRow(word: "crane", worst: 2, parts: 3, squares: 6, isCandidate: true),
        RankRow(word: "slate", worst: 2, parts: 3, squares: 6, isCandidate: true),
      ]
    )
    #expect(
      Ranking.rank(pool: ["stone", "crane"], candidates: ["crane", "slate"]) == [
        RankRow(word: "crane", worst: 1, parts: 2, squares: 2, isCandidate: true),
        RankRow(word: "stone", worst: 1, parts: 2, squares: 2, isCandidate: false),
      ]
    )
  }

  @Test func fullOrders() {
    #expect(
      Ranking.rank(pool: Lists.fiveWords, candidates: ["crate", "trace", "grace"]).map(\.word) == [
        "crate", "grace", "trace", "slate", "brace", "crane", "stone",
      ]
    )
  }
}
