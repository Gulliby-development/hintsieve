import Testing
@testable import HintSieveCore

@Suite struct TextInputTests {
  @Test func decodesValidText() throws {
    #expect(try TextInput.decode([0x61, 0x62], label: "w.txt") == "ab")
    #expect(try TextInput.decode([], label: "w.txt") == "")
    #expect(try TextInput.decode([0xEF, 0xBB, 0xBF, 0x61], label: "w.txt") == "a")
  }

  @Test func rejectsInvalidUtf8() {
    #expect(throws: Failure("hintsieve: w.txt: input is not valid UTF-8")) {
      try TextInput.decode([0xFF], label: "w.txt")
    }
    #expect(throws: Failure("hintsieve: w.txt: input is not valid UTF-8")) {
      try TextInput.decode([0xC0, 0xAF], label: "w.txt")
    }
  }

  @Test func labelAppearsInTheError() {
    #expect(throws: Failure("hintsieve: <stdin>: input is not valid UTF-8")) {
      try TextInput.decode([0xFF], label: "<stdin>")
    }
  }

  @Test func splitsLinesAndKeepsNumbers() {
    #expect(TextInput.lines("a\nb\n") == [Line(number: 1, text: "a"), Line(number: 2, text: "b")])
    #expect(TextInput.lines("a\nb") == [Line(number: 1, text: "a"), Line(number: 2, text: "b")])
    #expect(TextInput.lines("a\r\nb\r\n") == [Line(number: 1, text: "a"), Line(number: 2, text: "b")])
  }
}
