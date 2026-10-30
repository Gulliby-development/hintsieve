public struct CliResult: Equatable, Sendable {
  public let exit: Int32
  public let out: String
  public let err: String

  public init(exit: Int32, out: String, err: String) {
    self.exit = exit
    self.out = out
    self.err = err
  }
}

public enum Cli {
  static let usage =
    "usage: hintsieve COMMAND [ARGS]\n  score GUESS ANSWER\n  filter WORDS [--count] [CLUE...]\n  rank WORDS [--top N] [CLUE...]\n  split WORDS GUESS [CLUE...]\n  solve WORDS ANSWER [--first WORD] [--hard]\n  check WORDS LOG [--hard]\n"

  public static func run(
    _ args: [String],
    stdin: [UInt8] = [],
    read: @escaping (String) -> [UInt8]?
  ) -> CliResult {
    let env = Environment(stdin: stdin, read: read)
    do {
      let output = try dispatch(args, env)
      return CliResult(exit: output.exit, out: output.text, err: "")
    } catch let failure as Failure {
      return CliResult(exit: failure.code, out: "", err: failure.message + "\n")
    } catch {
      return CliResult(exit: 2, out: "", err: "hintsieve: internal error\n")
    }
  }

  public static func run(
    _ args: [String],
    stdin: [UInt8] = [],
    files: [String: [UInt8]] = [:]
  ) -> CliResult {
    run(args, stdin: stdin, read: { files[$0] })
  }

  static func dispatch(_ args: [String], _ env: Environment) throws -> Output {
    guard let command = args.first else {
      throw Failure(String(usage.dropLast()))
    }

    if command == "help" || command == "-h" || command == "--help" {
      return Output(exit: 0, text: usage)
    }

    let remaining = Array(args.dropFirst())
    switch command {
    case "score":
      return try ScoreCommand.run(remaining)
    case "filter":
      return try FilterCommand.run(remaining, env)
    case "rank":
      return try RankCommand.run(remaining, env)
    case "split":
      return try SplitCommand.run(remaining, env)
    case "solve":
      return try SolveCommand.run(remaining, env)
    case "check":
      return try CheckCommand.run(remaining, env)
    default:
      throw Failure("hintsieve: unknown command \"\(command)\"")
    }
  }
}
