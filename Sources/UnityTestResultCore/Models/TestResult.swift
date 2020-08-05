//
//  TestResult.swift
//  UnityTestResultCore
//
//  Created by Yuya Hirayama on 2020/08/05.
//

import Foundation

enum TestResult: String {
    init?(rawValue: String) {
        switch rawValue {
        case "Passed":
            self = .passed
        case "Failed", "Failed(Child)":
            self = .failed
        case "Inconclusive":
            self = .inconclusive
        case "Skipped":
            self = .skipped
        default:
            return nil
        }
    }

    case passed
    case failed
    case inconclusive
    case skipped
}
