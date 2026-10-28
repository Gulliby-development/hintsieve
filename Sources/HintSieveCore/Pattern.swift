enum Pattern {
  static let green: UInt8 = 103
  static let yellow: UInt8 = 121
  static let black: UInt8 = 98

  static func score(_ guess: String, _ answer: String) -> String {
    let guessBytes = Array(guess.utf8)
    let answerBytes = Array(answer.utf8)
    var pattern = [UInt8](repeating: black, count: guessBytes.count)
    var unmatchedAnswerCounts = [Int](repeating: 0, count: 256)

    for index in 0..<guessBytes.count {
      if guessBytes[index] == answerBytes[index] {
        pattern[index] = green
      } else {
        unmatchedAnswerCounts[Int(answerBytes[index])] += 1
      }
    }

    for index in 0..<guessBytes.count where pattern[index] != green {
      let letter = Int(guessBytes[index])
      if unmatchedAnswerCounts[letter] > 0 {
        pattern[index] = yellow
        unmatchedAnswerCounts[letter] -= 1
      }
    }

    return String(decoding: pattern, as: UTF8.self)
  }

  static func isAllGreen(_ pattern: String) -> Bool {
    pattern.utf8.allSatisfy { $0 == green }
  }
}
