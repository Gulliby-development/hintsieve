struct Parsed: Equatable {
  var positionals: [String] = []
  var values: [String: String] = [:]
}

enum Options {
  static func split(_ args: [String], takesValue: [String: Bool]) throws -> Parsed {
    var parsed = Parsed()
    var index = 0

    while index < args.count {
      let token = args[index]
      let bytes = Array(token.utf8)

      if bytes.count == 1, bytes[0] == 45 {
        parsed.positionals.append(token)
      } else if bytes.first == 45 {
        let equalsIndex = bytes.firstIndex(of: 61)
        let nameBytes = equalsIndex.map { bytes[..<$0] } ?? bytes[...]
        let name = String(decoding: nameBytes, as: UTF8.self)

        guard let expectsValue = takesValue[name] else {
          throw Failure("hintsieve: unknown option \"\(token)\"")
        }

        if let equalsIndex {
          guard expectsValue else {
            throw Failure("hintsieve: option \(name) takes no value")
          }
          let value = String(decoding: bytes[(equalsIndex + 1)...], as: UTF8.self)
          parsed.values[name] = value
        } else if expectsValue {
          let valueIndex = index + 1
          guard valueIndex < args.count else {
            throw Failure("hintsieve: option \(name) needs a value")
          }
          parsed.values[name] = args[valueIndex]
          index = valueIndex
        } else {
          parsed.values[name] = ""
        }
      } else {
        parsed.positionals.append(token)
      }

      index += 1
    }

    return parsed
  }

  static func top(_ text: String) throws -> Int {
    let bytes = Array(text.utf8)
    let isValidDigitCount = (1...4).contains(bytes.count)
    let hasOnlyAsciiDigits = bytes.allSatisfy { (48...57).contains($0) }

    guard isValidDigitCount, hasOnlyAsciiDigits, let value = Int(text), (1...9999).contains(value) else {
      throw Failure("hintsieve: bad --top value \"\(text)\": expected an integer from 1 to 9999")
    }

    return value
  }

  static func need(_ parsed: Parsed, _ low: Int, _ high: Int?, _ command: String) throws {
    let count = parsed.positionals.count
    guard count >= low, high.map({ count <= $0 }) ?? true else {
      throw Failure("hintsieve: \(command): wrong number of arguments")
    }
  }
}
