import Testing
@testable import HintSieveCore

@Suite struct LettersTests {
  @Test func lengthBounds() {
    #expect(Letters.isWord("crane", min: 2, max: 8) == true)
    #expect(Letters.isWord("ab", min: 2, max: 8) == true)
    #expect(Letters.isWord("abcdefgh", min: 2, max: 8) == true)
  }

  @Test func onlyLowercaseAscii() {
    #expect(Letters.isWord("Crane", min: 1, max: 8) == false)
    #expect(Letters.isWord("cr ne", min: 1, max: 8) == false)
    #expect(Letters.isWord("cr1ne", min: 1, max: 8) == false)
  }
}
