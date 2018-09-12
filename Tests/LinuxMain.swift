import XCTest

import StorageTests
import StorageServerTests

var tests = [XCTestCaseEntry]()
tests += StorageTests.__allTests()
tests += StorageServerTests.__allTests()

XCTMain(tests)
