struct Clue: Equatable {
  let word: String
  let pattern: String

  static func parse(_ text: String, size: Int) throws -> Clue {
    let bytes = Array(text.utf8)
    let colonIndices = bytes.indices.filter { bytes[$0] == 58 }
    guard colonIndices.count == 1, let colonIndex = colonIndices.first else {
      throw Failure("hintsieve: bad clue \"\(text)\": expected WORD:PATTERN")
    }

    let wordBytes = Array(bytes[..<colonIndex])
    let patternBytes = Array(bytes[(colonIndex + 1)...])
    let word = String(decoding: wordBytes, as: UTF8.self)
    guard Letters.isWord(word, min: size, max: size) else {
      throw Failure("hintsieve: bad clue \"\(text)\": word must be \(size) lowercase letters")
    }

    guard patternBytes.count == size,
      patternBytes.allSatisfy({ $0 == 103 || $0 == 121 || $0 == 98 })
    else {
      throw Failure("hintsieve: bad clue \"\(text)\": pattern must be \(size) characters of g, y, b")
    }

    return Clue(word: word, pattern: String(decoding: patternBytes, as: UTF8.self))
  }
}
