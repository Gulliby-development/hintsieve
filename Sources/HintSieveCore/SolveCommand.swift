enum SolveCommand {
  static func run(_ args: [String], _ env: Environment) throws -> Output {
    let parsed = try Options.split(args, takesValue: ["--first": true, "--hard": false])
    try Options.need(parsed, 2, 2, "solve")

    let (bytes, label) = try env.source(parsed.positionals[0])
    let words = try WordList.parse(bytes, label: label)
    let answer = parsed.positionals[1]

    guard words.contains(answer) else {
      throw Failure("hintsieve: answer \"\(answer)\" is not in the word list")
    }

    let first = parsed.values["--first"]
    if let first, !Letters.isWord(first, min: words[0].utf8.count, max: words[0].utf8.count) {
      throw Failure("hintsieve: bad word \"\(first)\": need \(words[0].utf8.count) lowercase letters")
    }

    let result = Solver.solve(
      words: words,
      answer: answer,
      first: first,
      hard: parsed.values["--hard"] != nil
    )
    let turns = result.turns.map(Lines.turn).joined()
    let footer = result.solved ? "solved in \(result.turns.count)\n" : "not solved in 10\n"
    return Output(exit: result.solved ? 0 : 1, text: turns + footer)
  }
}
