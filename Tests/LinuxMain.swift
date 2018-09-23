import XCTest

import StorageServerTests
import StorageTests

var tests = [XCTestCaseEntry]()
tests += StorageServerTests.__allTests()
tests += StorageTests.__allTests()

XCTMain(tests)
