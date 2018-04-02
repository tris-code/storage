import XCTest

extension ContainerTests {
    static let __allTests = [
        ("testFirst", testFirst),
        ("testInit", testInit),
        ("testInsert", testInsert),
        ("testRemove", testRemove),
        ("testSelect", testSelect),
        ("testUpdate", testUpdate),
    ]
}

extension StorageTests {
    static let __allTests = [
        ("testClassType", testClassType),
        ("testInit", testInit),
        ("testRecovery", testRecovery),
        ("testSnapshot", testSnapshot),
        ("testStorage", testStorage),
        ("testStoragePersistence", testStoragePersistence),
    ]
}

extension WALTests {
    static let __allTests = [
        ("testInit", testInit),
        ("testRestore", testRestore),
        ("testWrite", testWrite),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ContainerTests.__allTests),
        testCase(StorageTests.__allTests),
        testCase(WALTests.__allTests),
    ]
}
#endif
