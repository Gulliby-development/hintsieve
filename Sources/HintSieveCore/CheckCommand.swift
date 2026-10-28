enum CheckCommand {
  static func run(_ args: [String], _ env: Environment) throws -> Output {
    let parsed = try Options.split(args, takesValue: ["--hard": false])
    try Options.need(parsed, 2, 2, "check")

    let (wordBytes, wordLabel) = try env.source(parsed.positionals[0])
    let words = try WordList.parse(wordBytes, label: wordLabel)
    let logPath = parsed.positionals[1]

    guard logPath != "-" else {
      throw Failure("hintsieve: check reads its log from a file, not from stdin")
    }
    guard let logBytes = env.read(logPath) else {
      throw Failure("hintsieve: \(logPath): cannot read file")
    }

    let logText = try TextInput.decode(logBytes, label: logPath)
    var clues: [Clue] = []

    for line in TextInput.lines(logText) {
      if line.text.isEmpty || line.text.utf8.first == 35 {
        continue
      }

      do {
        clues.append(try Clue.parse(line.text, size: words[0].utf8.count))
      } catch is Failure {
        throw Failure("hintsieve: \(logPath):\(line.number): not a clue of the form WORD:PATTERN")
      }
    }

    let verdicts = Transcript.check(words: words, clues: clues, hard: parsed.values["--hard"] != nil)
    let text = verdicts.map(Lines.verdict).joined()
    let exit: Int32 = verdicts.allSatisfy { $0.status == "ok" } ? 0 : 1
    return Output(exit: exit, text: text)
  }
}
