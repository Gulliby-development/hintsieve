import Foundation
import Testing

@Suite struct ProcessTests {
  @Test func badUtf8OnStandardInputExitsTwo() throws {
    let name = "hintsieve" + (ProcessInfo.processInfo.environment["OS"] == "Windows_NT" ? ".exe" : "")
    let package = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()
      .deletingLastPathComponent()
    let build = package.appendingPathComponent(".build")
    let found = FileManager.default.enumerator(at: build, includingPropertiesForKeys: nil)?
      .compactMap { $0 as? URL }
      .first { $0.lastPathComponent == name && FileManager.default.isExecutableFile(atPath: $0.path) }
    let executable = try #require(found)
    let process = Process()
    process.executableURL = executable
    process.arguments = ["filter", "-"]
    let input = Pipe()
    let output = Pipe()
    let errors = Pipe()
    process.standardInput = input
    process.standardOutput = output
    process.standardError = errors
    try process.run()
    input.fileHandleForWriting.write(Data([0xFF]))
    try input.fileHandleForWriting.close()
    let err = errors.fileHandleForReading.readDataToEndOfFile()
    let out = output.fileHandleForReading.readDataToEndOfFile()
    process.waitUntilExit()
    #expect(process.terminationStatus == 2)
    #expect(out.isEmpty)
    #expect(String(decoding: err, as: UTF8.self) == "hintsieve: <stdin>: input is not valid UTF-8\n")
  }
}
