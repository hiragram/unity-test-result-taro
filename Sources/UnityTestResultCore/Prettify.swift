//
//  Prettify.swift
//  unity-test-result-taro
//
//  Created by Yuya Hirayama on 2020/08/05.
//

import Foundation
import ArgumentParser
import SwiftyXMLParser
import Rainbow

public struct Prettify: ParsableCommand {
    @Argument
    var xmlFile: String

    @Flag
    var isCI: Bool = false

    @Flag
    var disableColor: Bool = false

    public init() {}

    public func run() throws {
        let xmlData = FileManager.default.contents(atPath: xmlFile)!
        let testRun = try parseXML(data: xmlData)
        print(prettify(test: testRun))

        switch testRun.result {
        case .failed:
            throw TestError.failed
        default:
            break
        }
    }

    private func prettifyRow(suite: TestSuite, depthLevel: Int) -> String {
        func indent(_ relativeLevel: Int) -> String {
            (0..<depthLevel + relativeLevel).map({_ in "  "}).joined()
        }

        let caseRows = suite.cases.map {
            "\(indent(1))\($0.result.headMarker) \($0.methodName) in \($0.duration) seconds."
        }

        let childRows = suite.suites.map {
            prettifyRow(suite: $0, depthLevel: depthLevel + 1)
        }

        let selfResult = "\(indent(0))\(suite.result.headMarker) \(suite.name) \(suite.passedTestCaseCount) passed, \(suite.failedTestCaseCount) failed, \(suite.skippedTestCaseCount) skipped, \(suite.inconclusiveTestCaseCount) inconclusive in \(suite.duration) seconds."

        return [
            selfResult,
            caseRows.joined(separator: "\n") + childRows.joined(separator: "\n")
            ].joined(separator: "\n")
    }

    func prettify(test: TestRun) -> String {
        var results: [String] = []

        results += test.suites.map {
            prettifyRow(suite: $0, depthLevel: 0)
        }

        do {
            results.append("")
            results.append("Test result:")
            results.append("\(test.result.headMarker) \(test.testCaseCount) cases, \(test.passedTestCaseCount) passed, \(test.failedTestCaseCount) failed, \(test.skippedTestCaseCount) skipped, \(test.inconclusiveTestCaseCount) inconclusive.")
        }

        return results.joined(separator: "\n")
    }

    func parseXML(data: Data) throws -> TestRun {
        let xml = XML.parse(data)

        let testRunAccessor = xml["test-run"]

        let testRunNode: XML.Element
        switch testRunAccessor {
        case .singleElement(let element):
            testRunNode = element
        default:
            fatalError()
        }

        return try parseTestRun(testRunNode: testRunNode)
    }

    private func parseTestRun(testRunNode: XML.Element) throws -> TestRun {
        guard let id = testRunNode.attributes["id"] else {
            throw ParseError.attributeNotFound(name: "id", nodeClass: "test-run", nodeID: "N/A")
        }

        guard let passedCount = testRunNode.attributes["passed"].flatMap(Int.init) else {
            throw ParseError.attributeNotFound(name: "passed", nodeClass: "test-run", nodeID: id)
        }

        guard let failedCount = testRunNode.attributes["failed"].flatMap(Int.init) else {
            throw ParseError.attributeNotFound(name: "failed", nodeClass: "test-run", nodeID: id)
        }

        guard let inconclusiveCount = testRunNode.attributes["inconclusive"].flatMap(Int.init) else {
            throw ParseError.attributeNotFound(name: "inconclusive", nodeClass: "test-run", nodeID: id)
        }

        guard let skippedCount = testRunNode.attributes["skipped"].flatMap(Int.init) else {
            throw ParseError.attributeNotFound(name: "skipped", nodeClass: "test-run", nodeID: id)
        }

        guard let assertionCount = testRunNode.attributes["asserts"].flatMap(Int.init) else {
            throw ParseError.attributeNotFound(name: "asserts", nodeClass: "test-run", nodeID: id)
        }

        guard let duration = testRunNode.attributes["duration"].flatMap(TimeInterval.init) else {
            throw ParseError.attributeNotFound(name: "duration", nodeClass: "test-run", nodeID: id)
        }

        guard let testCaseCount = testRunNode.attributes["testcasecount"].flatMap(Int.init) else {
            throw ParseError.attributeNotFound(name: "testcasecount", nodeClass: "test-run", nodeID: id)
        }

        guard let result = testRunNode.attributes["result"].flatMap(TestResult.init) else {
            throw ParseError.attributeNotFound(name: "result", nodeClass: "test-run", nodeID: id)
        }

        let suitesAccessor = XML.Accessor.init(testRunNode)["test-suite"]

        let suiteNodes: [XML.Element]
        switch suitesAccessor {
        case .singleElement(let element):
            suiteNodes = [element]
        case .sequence(let elements):
            suiteNodes = elements
        case .failure(let error):
            throw error
        }

        return try TestRun(
            id: id,
            testCaseCount: testCaseCount,
            result: result,
            passedTestCaseCount: passedCount,
            failedTestCaseCount: failedCount,
            inconclusiveTestCaseCount: inconclusiveCount,
            skippedTestCaseCount: skippedCount,
            assertionCount: assertionCount,
            duration: duration,
            suites: suiteNodes.map(parseTestSuite(testSuiteNode:))
        )
    }

    private func parseTestSuite(testSuiteNode: XML.Element) throws -> TestSuite {
        guard let assertionCount = testSuiteNode.attributes["asserts"].flatMap(Int.init) else {
            throw ParseError.attributeNotFound(name: "asserts", nodeClass: "test-suite", nodeID: "N/A")
        }

        let className = testSuiteNode.attributes["classname"]

        guard let duration = testSuiteNode.attributes["duration"].flatMap(TimeInterval.init) else {
            throw ParseError.attributeNotFound(name: "duration", nodeClass: "test-suite", nodeID: "N/A")
        }

        guard let failedCount = testSuiteNode.attributes["failed"].flatMap(Int.init) else {
            throw ParseError.attributeNotFound(name: "failed", nodeClass: "test-suite", nodeID: "N/A")
        }

        guard let fullName = testSuiteNode.attributes["fullname"] else {
            throw ParseError.attributeNotFound(name: "fullname", nodeClass: "test-suite", nodeID: "N/A")
        }

        guard let inconclusiveCount = testSuiteNode.attributes["inconclusive"].flatMap(Int.init) else {
            throw ParseError.attributeNotFound(name: "inconclusive", nodeClass: "test-suite", nodeID: "N/A")
        }

        guard let name = testSuiteNode.attributes["name"] else {
            throw ParseError.attributeNotFound(name: "name", nodeClass: "test-suite", nodeID: "N/A")
        }

        guard let passedCount = testSuiteNode.attributes["passed"].flatMap(Int.init) else {
            throw ParseError.attributeNotFound(name: "passed", nodeClass: "test-suite", nodeID: "N/A")
        }

        guard let result = testSuiteNode.attributes["result"].flatMap(TestResult.init) else {
            throw ParseError.attributeNotFound(name: "result", nodeClass: "test-suite", nodeID: "N/A")
        }

        guard let runState = testSuiteNode.attributes["runstate"].flatMap(RunState.init) else {
            throw ParseError.attributeNotFound(name: "runstate", nodeClass: "test-suite", nodeID: "N/A")
        }

        guard let skippedCount = testSuiteNode.attributes["skipped"].flatMap(Int.init) else {
            throw ParseError.attributeNotFound(name: "skipped", nodeClass: "test-suite", nodeID: "N/A")
        }

        guard let testCaseCount = testSuiteNode.attributes["testcasecount"].flatMap(Int.init) else {
            throw ParseError.attributeNotFound(name: "testcasecount", nodeClass: "test-suite", nodeID: "N/A")
        }

        let accessor = XML.Accessor(testSuiteNode)

        let childSuites: [XML.Element]
        switch accessor["test-suite"] {
        case .singleElement(let element):
            childSuites = [element]
        case .sequence(let elements):
            childSuites = elements
        case .failure(_):
            childSuites = []
        }

        let childProperties: [XML.Element]
        switch accessor["properties", "property"] {
        case .singleElement(let element):
            childProperties = [element]
        case .sequence(let elements):
            childProperties = elements
        case .failure(_):
            childProperties = []
        }

        let childCases: [XML.Element]
        switch accessor["test-case"] {
        case .singleElement(let element):
            childCases = [element]
        case .sequence(let elements):
            childCases = elements
        case .failure(_):
            childCases = []
        }

        return TestSuite.init(
            name: name,
            fullName: fullName,
            className: className,
            runState: runState,
            testCaseCount: testCaseCount,
            result: result,
            duration: duration,
            passedTestCaseCount: passedCount,
            failedTestCaseCount: failedCount,
            inconclusiveTestCaseCount: inconclusiveCount,
            skippedTestCaseCount: skippedCount,
            assertionCount: assertionCount,
            suites: try childSuites.map(parseTestSuite(testSuiteNode:)),
            properties: try childProperties.map(parseProperty(propertyNode:)),
            cases: try childCases.map(parseTestCase(testCaseNode:))
        )
    }

    private func parseProperty(propertyNode: XML.Element) throws -> Property {
        guard let name = propertyNode.attributes["name"] else {
            throw ParseError.attributeNotFound(name: "name", nodeClass: "property", nodeID: "N/A")
        }

        guard let value = propertyNode.attributes["value"] else {
            throw ParseError.attributeNotFound(name: "value", nodeClass: "property", nodeID: "N/A")
        }

        return Property.init(
            name: name,
            value: value
        )
    }

    private func parseTestCase(testCaseNode: XML.Element) throws -> TestCase {
        guard let name = testCaseNode.attributes["name"] else {
            throw ParseError.attributeNotFound(name: "name", nodeClass: "test-case", nodeID: "N/A")
        }

        guard let fullName = testCaseNode.attributes["fullname"] else {
            throw ParseError.attributeNotFound(name: "fullname", nodeClass: "test-case", nodeID: "N/A")
        }

        guard let methodName = testCaseNode.attributes["methodname"] else {
            throw ParseError.attributeNotFound(name: "methodname", nodeClass: "test-case", nodeID: "N/A")
        }

        guard let className = testCaseNode.attributes["classname"] else {
            throw ParseError.attributeNotFound(name: "classname", nodeClass: "test-case", nodeID: "N/A")
        }

        guard let result = testCaseNode.attributes["result"].flatMap(TestResult.init) else {
            throw ParseError.attributeNotFound(name: "result", nodeClass: "test-suite", nodeID: "N/A")
        }

        guard let runState = testCaseNode.attributes["runstate"].flatMap(RunState.init) else {
            throw ParseError.attributeNotFound(name: "runstate", nodeClass: "test-suite", nodeID: "N/A")
        }

        guard let duration = testCaseNode.attributes["duration"].flatMap(TimeInterval.init) else {
            throw ParseError.attributeNotFound(name: "duration", nodeClass: "test-suite", nodeID: "N/A")
        }

        guard let assertionCount = testCaseNode.attributes["asserts"].flatMap(Int.init) else {
            throw ParseError.attributeNotFound(name: "asserts", nodeClass: "test-suite", nodeID: "N/A")
        }

        let accessor = XML.Accessor(testCaseNode)

        let childProperties: [XML.Element]
        switch accessor["property"] {
        case .singleElement(let element):
            childProperties = [element]
        case .sequence(let elements):
            childProperties = elements
        case .failure(_):
            childProperties = []
        }

        return TestCase.init(
            name: name,
            fullName: fullName,
            methodName: methodName,
            className: className,
            runState: runState,
            result: result,
            duration: duration,
            assertionCount: assertionCount,
            properties: try childProperties.map(parseProperty(propertyNode:))
        )
    }
}

enum ParseError: Error {
    case attributeNotFound(name: String, nodeClass: String, nodeID: String)
}

extension TestResult {
    var headMarker: String {
        switch self {
        case .passed:
            return "[PASS]".green
        case .failed:
            return "[FAIL]".red
        case .skipped:
            return "[SKIP]".lightWhite
        case .inconclusive:
            return "[????]".lightYellow
        }
    }
}

enum TestError: Error {
    case failed
}
