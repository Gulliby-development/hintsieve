import Foundation
import HintSieveCore

func readFile(_ path: String) -> [UInt8]? {
  guard let data = FileManager.default.contents(atPath: path) else { return nil }
  return [UInt8](data)
}

let args = Array(CommandLine.arguments.dropFirst())
let input: [UInt8] =
  args.contains("-") ? [UInt8](FileHandle.standardInput.readDataToEndOfFile()) : []
let result = Cli.run(args, stdin: input, read: readFile)
FileHandle.standardOutput.write(Data(result.out.utf8))
FileHandle.standardError.write(Data(result.err.utf8))
exit(result.exit)
