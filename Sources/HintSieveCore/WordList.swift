enum WordList {
  static func parse(_ bytes: [UInt8], label: String) throws -> [String] {
    let text = try TextInput.decode(bytes, label: label)
    let lines = TextInput.lines(text)
    var words: [String] = []
    var seen: Set<String> = []
    var expectedLength: Int?

    for line in lines {
      if line.text.isEmpty || line.text.utf8.first == 35 {
        continue
      }

      guard Letters.isWord(line.text, min: 2, max: 8) else {
        throw Failure("hintsieve: \(label):\(line.number): not a lowercase word of 2 to 8 letters")
      }

      let length = line.text.utf8.count
      if let expectedLength, length != expectedLength {
        throw Failure("hintsieve: \(label):\(line.number): word has \(length) letters, expected \(expectedLength)")
      }
      if expectedLength == nil {
        expectedLength = length
      }

      guard seen.insert(line.text).inserted else {
        throw Failure("hintsieve: \(label):\(line.number): duplicate word")
      }

      words.append(line.text)
    }

    guard !words.isEmpty else {
      throw Failure("hintsieve: \(label): no words")
    }
    return words
  }
}
