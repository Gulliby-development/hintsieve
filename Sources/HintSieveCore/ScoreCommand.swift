enum ScoreCommand {
  static func run(_ args: [String]) throws -> Output {
    let parsed = try Options.split(args, takesValue: [:])
    try Options.need(parsed, 2, 2, "score")

    let guess = parsed.positionals[0]
    let answer = parsed.positionals[1]

    guard Letters.isWord(guess, min: 2, max: 8) else {
      throw Failure("hintsieve: bad word \"\(guess)\": need 2 to 8 lowercase letters")
    }
    guard Letters.isWord(answer, min: 2, max: 8) else {
      throw Failure("hintsieve: bad word \"\(answer)\": need 2 to 8 lowercase letters")
    }

    let guessLength = guess.utf8.count
    let answerLength = answer.utf8.count
    guard guessLength == answerLength else {
      throw Failure("hintsieve: length mismatch: \(guessLength) and \(answerLength)")
    }

    return Output(exit: 0, text: Pattern.score(guess, answer) + "\n")
  }
}
