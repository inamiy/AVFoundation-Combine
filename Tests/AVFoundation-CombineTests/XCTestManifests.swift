import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AVFoundation_CombineTests.allTests),
    ]
}
#endif
