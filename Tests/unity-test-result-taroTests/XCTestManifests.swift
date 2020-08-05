import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(unity_test_result_taroTests.allTests),
    ]
}
#endif
