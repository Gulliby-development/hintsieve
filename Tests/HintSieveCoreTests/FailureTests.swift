import Testing
@testable import HintSieveCore

@Suite struct FailureTests {
  @Test func defaultCodeIsTwo() {
    #expect(Failure("x").code == 2)
    #expect(Failure("x").message == "x")
  }

  @Test func equality() {
    #expect(Failure("x") == Failure("x", code: 2))
    #expect(Failure("x") != Failure("x", code: 1))
  }
}
