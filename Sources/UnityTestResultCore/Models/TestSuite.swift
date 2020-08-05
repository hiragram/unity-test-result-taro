//
//  TestSuite.swift
//  UnityTestResultCore
//
//  Created by Yuya Hirayama on 2020/08/05.
//

import Foundation

struct TestSuite: Equatable {
    public var name: String
    public var fullName: String
    public var className: String?
    public var runState: RunState
    public var testCaseCount: Int
    public var result: TestResult
    public var duration: TimeInterval
    public var passedTestCaseCount: Int
    public var failedTestCaseCount: Int
    public var inconclusiveTestCaseCount: Int
    public var skippedTestCaseCount: Int
    public var assertionCount: Int
    public var suites: [TestSuite]
    public var properties: [Property]
    public var cases: [TestCase]
}

enum RunState: String, Equatable {
    case notRunnable = "NotRunnable"
    case runnable = "Runnable"
    case explicit = "Explicit"
    case skipped = "Skipped"
    case ignored = "Ignored"
}
