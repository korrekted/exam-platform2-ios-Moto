//
//  QuestionManagerDelagate.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 27.02.2021.
//

import Foundation

protocol QuestionManagerDelegate: AnyObject {
    func didTestPassed()
    func didTestClosed()
    func didTimedTestClosed(userTestId: Int)
}
