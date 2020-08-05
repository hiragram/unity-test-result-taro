@testable import UnityTestResultCore
import XCTest
import class Foundation.Bundle

final class PrettifyTests: XCTestCase {
    func testParse() throws {
        let p = Prettify.init()
        let result = try p.parseXML(data: xml)

        XCTAssertEqual(result.assertionCount, 0)
        XCTAssertEqual(result.duration, 0.9348291)
        XCTAssertEqual(result.failedTestCaseCount, 0)
        XCTAssertEqual(result.id, "2")
        XCTAssertEqual(result.inconclusiveTestCaseCount, 0)
        XCTAssertEqual(result.passedTestCaseCount, 1)
        XCTAssertEqual(result.result, .passed)
        XCTAssertEqual(result.skippedTestCaseCount, 0)
        XCTAssertEqual(result.testCaseCount, 1)

        let suites = TestSuite.init(
            name: "project-zero",
            fullName: "project-zero",
            className: nil,
            runState: .runnable,
            testCaseCount: 1,
            result: .passed,
            duration: 0.9348291,
            passedTestCaseCount: 1,
            failedTestCaseCount: 0,
            inconclusiveTestCaseCount: 0,
            skippedTestCaseCount: 0,
            assertionCount: 0,
            suites: [
                TestSuite.init(
                    name: "VRMLoaderTests.dll",
                    fullName: "/Users/hiragram/Development/project-zero/Library/ScriptAssemblies/VRMLoaderTests.dll",
                    className: nil,
                    runState: .runnable,
                    testCaseCount: 1,
                    result: .passed,
                    duration: 0.815180,
                    passedTestCaseCount: 1,
                    failedTestCaseCount: 0,
                    inconclusiveTestCaseCount: 0,
                    skippedTestCaseCount: 0,
                    assertionCount: 0,
                    suites: [
                        TestSuite.init(
                            name: "Tests",
                            fullName: "Tests",
                            className: nil,
                            runState: .runnable,
                            testCaseCount: 1,
                            result: .passed,
                            duration: 0.723673,
                            passedTestCaseCount: 1,
                            failedTestCaseCount: 0,
                            inconclusiveTestCaseCount: 0,
                            skippedTestCaseCount: 0,
                            assertionCount: 0,
                            suites: [
                                TestSuite.init(
                                    name: "VRMLoaderTests",
                                    fullName: "Tests.VRMLoaderTests",
                                    className: "Tests.VRMLoaderTests",
                                    runState: .runnable,
                                    testCaseCount: 1,
                                    result: .passed,
                                    duration: 0.621529,
                                    passedTestCaseCount: 1,
                                    failedTestCaseCount: 0,
                                    inconclusiveTestCaseCount: 0,
                                    skippedTestCaseCount: 0,
                                    assertionCount: 0,
                                    suites: [],
                                    properties: [],
                                    cases: [
                                        TestCase.init(
                                            name: "LoadVRMTest",
                                            fullName: "Tests.VRMLoaderTests.LoadVRMTest",
                                            methodName: "LoadVRMTest",
                                            className: "Tests.VRMLoaderTests",
                                            runState: .runnable,
                                            result: .passed,
                                            duration: 0.505970,
                                            assertionCount: 0,
                                            properties: []
                                        )
                                    ]
                                )
                            ],
                            properties: [],
                            cases: []
                        )
                    ],
                    properties: [
                        Property.init(
                            name: "_PID",
                            value: "35219"
                        ),
                        Property.init(
                            name: "_APPDOMAIN",
                            value: "Unity Child Domain"
                        ),
                        Property.init(
                            name: "platform",
                            value: "EditMode"
                        ),
                    ],
                    cases: []
                )
            ],
            properties: [],
            cases: []
        )

        XCTAssertEqual(result.suites.count, 1)

        let actualSuite = result.suites.first!
        let expectedSuite = suites

        XCTAssertEqual(actualSuite.assertionCount, expectedSuite.assertionCount)
        XCTAssertEqual(actualSuite.cases, expectedSuite.cases)
        XCTAssertEqual(actualSuite.className, expectedSuite.className)
        XCTAssertEqual(Int(actualSuite.duration * 1000), Int(expectedSuite.duration * 1000))
        XCTAssertEqual(actualSuite.failedTestCaseCount, expectedSuite.failedTestCaseCount)
        XCTAssertEqual(actualSuite.fullName, expectedSuite.fullName)
        XCTAssertEqual(actualSuite.inconclusiveTestCaseCount, expectedSuite.inconclusiveTestCaseCount)
        XCTAssertEqual(actualSuite.name, expectedSuite.name)
        XCTAssertEqual(actualSuite.passedTestCaseCount, expectedSuite.passedTestCaseCount)
        XCTAssertEqual(actualSuite.properties, expectedSuite.properties)
        XCTAssertEqual(actualSuite.result, expectedSuite.result)
        XCTAssertEqual(actualSuite.runState, expectedSuite.runState)
        XCTAssertEqual(actualSuite.skippedTestCaseCount, expectedSuite.skippedTestCaseCount)
        XCTAssertEqual(actualSuite.suites, expectedSuite.suites)
        XCTAssertEqual(actualSuite.testCaseCount, expectedSuite.testCaseCount)
    }
}

let xml: Data =
"""
<?xml version="1.0" encoding="utf-8"?>
    <test-run id="2" testcasecount="1" result="Passed" total="1" passed="1" failed="0" inconclusive="0" skipped="0" asserts="0" engine-version="3.5.0.0" clr-version="4.0.30319.42000" start-time="2020-08-05 04:49:40Z" end-time="2020-08-05 04:49:41Z" duration="0.9348291">
        <test-suite type="TestSuite" id="1014" name="project-zero" fullname="project-zero" runstate="Runnable" testcasecount="1" result="Passed" start-time="2020-08-05 04:49:40Z" end-time="2020-08-05 04:49:41Z" duration="0.934829" total="1" passed="1" failed="0" inconclusive="0" skipped="0" asserts="0">
            <properties />
            <test-suite type="Assembly" id="1019" name="VRMLoaderTests.dll" fullname="/Users/hiragram/Development/project-zero/Library/ScriptAssemblies/VRMLoaderTests.dll" runstate="Runnable" testcasecount="1" result="Passed" start-time="2020-08-05 04:49:40Z" end-time="2020-08-05 04:49:41Z" duration="0.815180" total="1" passed="1" failed="0" inconclusive="0" skipped="0" asserts="0">
                <properties>
                    <property name="_PID" value="35219" />
                    <property name="_APPDOMAIN" value="Unity Child Domain" />
                    <property name="platform" value="EditMode" />
                </properties>
                <test-suite type="TestSuite" id="1020" name="Tests" fullname="Tests" runstate="Runnable" testcasecount="1" result="Passed" start-time="2020-08-05 04:49:40Z" end-time="2020-08-05 04:49:41Z" duration="0.723673" total="1" passed="1" failed="0" inconclusive="0" skipped="0" asserts="0">
                    <properties />
                    <test-suite type="TestFixture" id="1017" name="VRMLoaderTests" fullname="Tests.VRMLoaderTests" classname="Tests.VRMLoaderTests" runstate="Runnable" testcasecount="1" result="Passed" start-time="2020-08-05 04:49:40Z" end-time="2020-08-05 04:49:41Z" duration="0.621529" total="1" passed="1" failed="0" inconclusive="0" skipped="0" asserts="0">
                        <properties />
                        <test-case id="1018" name="LoadVRMTest" fullname="Tests.VRMLoaderTests.LoadVRMTest" methodname="LoadVRMTest" classname="Tests.VRMLoaderTests" runstate="Runnable" seed="1088150566" result="Passed" start-time="2020-08-05 04:49:40Z" end-time="2020-08-05 04:49:41Z" duration="0.505970" asserts="0">
                            <properties />
                            <output><![CDATA[meta: title: zero_lightweight]]></output>
                        </test-case>
                    </test-suite>
                </test-suite>
            </test-suite>
        </test-suite>
    </test-run>
""".data(using: .utf8)!
