//
//  QuestionManagerDelagate.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 27.02.2021.
//

import Foundation

protocol QuestionManagerDelegate: class {
    func didTestPassed()
    func didTestClosed()
}
