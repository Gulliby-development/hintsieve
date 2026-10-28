import Testing
@testable import HintSieveCore

@Suite struct PartitionTests {
  enum Lists {
    static let fiveWords = ["crane", "slate", "trace", "crate", "grace", "brace", "stone"]
  }

  @Test func groupsByPatternInOrder() {
    #expect(
      Partition.buckets("crane", Lists.fiveWords) == [
        Bucket(pattern: "bbbgg", words: ["stone"]),
        Bucket(pattern: "bbgbg", words: ["slate"]),
        Bucket(pattern: "gggbg", words: ["crate"]),
        Bucket(pattern: "ggggg", words: ["crane"]),
        Bucket(pattern: "yggbg", words: ["trace", "grace", "brace"]),
      ]
    )
    #expect(
      Partition.buckets("trace", Array(Lists.fiveWords.prefix(5))) == [
        Bucket(pattern: "bgggg", words: ["grace"]),
        Bucket(pattern: "bggyg", words: ["crane"]),
        Bucket(pattern: "ggggg", words: ["trace"]),
        Bucket(pattern: "ybgbg", words: ["slate"]),
        Bucket(pattern: "yggyg", words: ["crate"]),
      ]
    )
    #expect(Partition.buckets("aaa", ["aaa"]) == [Bucket(pattern: "ggg", words: ["aaa"])])
  }
}
