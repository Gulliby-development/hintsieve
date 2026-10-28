import Testing
@testable import HintSieveCore

@Suite struct WordListTests {
  @Test func parsesWords() throws {
    #expect(try WordList.parse(Array("crane\nslate\n".utf8), label: "w.txt") == ["crane", "slate"])
    #expect(try WordList.parse(Array("crane\r\nslate\r\n".utf8), label: "w.txt") == ["crane", "slate"])
  }

  @Test func rejectsBadLists() {
    #expect(throws: Failure("hintsieve: w.txt:2: not a lowercase word of 2 to 8 letters")) {
      try WordList.parse(Array("crane\nSlate\n".utf8), label: "w.txt")
    }
    #expect(throws: Failure("hintsieve: w.txt:2: not a lowercase word of 2 to 8 letters")) {
      try WordList.parse(Array("crane\nsl4te\n".utf8), label: "w.txt")
    }
    #expect(throws: Failure("hintsieve: w.txt:3: not a lowercase word of 2 to 8 letters")) {
      try WordList.parse(Array("crane\n\na\n".utf8), label: "w.txt")
    }
  }

  @Test func labelsAndLineNumbers() {
    #expect(throws: Failure("hintsieve: <stdin>:2: word has 3 letters, expected 2")) {
      try WordList.parse(Array("ab\nabc\n".utf8), label: "<stdin>")
    }
    #expect(throws: Failure("hintsieve: words.txt: input is not valid UTF-8")) {
      try WordList.parse([0x61, 0xFF], label: "words.txt")
    }
  }
}
