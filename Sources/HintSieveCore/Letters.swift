enum Letters {
  static func isWord(_ text: String, min: Int, max: Int) -> Bool {
    let bytes = text.utf8
    guard bytes.count >= min, bytes.count <= max else {
      return false
    }
    return bytes.allSatisfy { $0 >= 97 && $0 <= 122 }
  }
}
