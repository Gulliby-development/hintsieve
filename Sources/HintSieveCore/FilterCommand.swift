enum FilterCommand {
  static func run(_ args: [String], _ env: Environment) throws -> Output {
    let parsed = try Options.split(args, takesValue: [:])
    try Options.need(parsed, 1, nil, "filter")

    let source = try env.source(parsed.positionals[0])
    let words = try WordList.parse(source.bytes, label: source.label)
    let clues = Array(parsed.positionals.dropFirst())
    let candidates = try Candidates.apply(words, clues: clues)

    let candidateLines = candidates.map { "\($0)\n" }.joined()
    let text = candidateLines + "\(candidates.count) of \(words.count)\n"
    return Output(exit: candidates.isEmpty ? 1 : 0, text: text)
  }
}
