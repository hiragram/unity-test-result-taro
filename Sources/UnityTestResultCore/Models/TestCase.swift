//
//  TestCase.swift
//  UnityTestResultCore
//
//  Created by Yuya Hirayama on 2020/08/05.
//

import Foundation

struct TestCase: Equatable {
    public var name: String
    public var fullName: String
    public var methodName: String
    public var className: String
    public var runState: RunState
    public var result: TestResult
    public var duration: TimeInterval
    public var assertionCount: Int
    public var properties: [Property]
}
