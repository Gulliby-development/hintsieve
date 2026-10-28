struct Failure: Error, Equatable {
  let message: String
  let code: Int32

  init(_ message: String, code: Int32 = 2) {
    self.message = message
    self.code = code
  }
}
