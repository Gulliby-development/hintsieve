// swift-tools-version: 6.2
import PackageDescription

let strict: [SwiftSetting] = [.treatAllWarnings(as: .error)]

let package = Package(
  name: "hintsieve",
  platforms: [.macOS(.v15)],
  targets: [
    .target(name: "HintSieveCore", swiftSettings: strict),
    .executableTarget(name: "hintsieve", dependencies: ["HintSieveCore"], swiftSettings: strict),
    .testTarget(name: "HintSieveCoreTests", dependencies: ["HintSieveCore"], swiftSettings: strict),
  ]
)
