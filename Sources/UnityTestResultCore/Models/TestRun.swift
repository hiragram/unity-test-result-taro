//
//  TestRun.swift
//  ArgumentParser
//
//  Created by Yuya Hirayama on 2020/08/05.
//

import Foundation

struct TestRun {
    public var id: String
    public var testCaseCount: Int
    public var result: TestResult
    public var passedTestCaseCount: Int
    public var failedTestCaseCount: Int
    public var inconclusiveTestCaseCount: Int
    public var skippedTestCaseCount: Int
    public var assertionCount: Int
    public var duration: TimeInterval
    public var suites: [TestSuite]
}

