struct Line: Equatable {
  let number: Int
  let text: String
}

enum TextInput {
  static func decode(_ bytes: [UInt8], label: String) throws -> String {
    guard let decoded = String(validating: bytes, as: UTF8.self) else {
      throw Failure("hintsieve: \(label): input is not valid UTF-8")
    }

    guard bytes.starts(with: [0xEF, 0xBB, 0xBF]) else {
      return decoded
    }
    return String(decoding: bytes.dropFirst(3), as: UTF8.self)
  }

  static func lines(_ text: String) -> [Line] {
    let bytes = [UInt8](text.utf8)
    guard !bytes.isEmpty else {
      return []
    }

    var result: [Line] = []
    var start = 0
    var number = 1

    for index in bytes.indices where bytes[index] == 10 {
      var lineBytes = bytes[start..<index]
      if lineBytes.last == 13 {
        lineBytes = lineBytes.dropLast()
      }
      result.append(Line(number: number, text: String(decoding: lineBytes, as: UTF8.self)))
      start = index + 1
      number += 1
    }

    if start < bytes.count {
      var lineBytes = bytes[start..<bytes.count]
      if lineBytes.last == 13 {
        lineBytes = lineBytes.dropLast()
      }
      result.append(Line(number: number, text: String(decoding: lineBytes, as: UTF8.self)))
    }

    return result
  }
}
