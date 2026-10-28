struct Environment {
  let stdin: [UInt8]
  let read: (String) -> [UInt8]?

  func source(_ path: String) throws -> (bytes: [UInt8], label: String) {
    if path == "-" {
      return (bytes: stdin, label: "<stdin>")
    }

    guard let bytes = read(path) else {
      throw Failure("hintsieve: \(path): cannot read file")
    }
    return (bytes: bytes, label: path)
  }
}
