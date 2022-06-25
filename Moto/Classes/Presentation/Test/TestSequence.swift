//
//  TestSequence.swift
//  Moto
//
//  Created by Андрей Чернышев on 25.06.2022.
//

import UIKit

final class TestSequence {
    private var testTypes: [TestType]
    private let course: Course
    private let isTopicTest: Bool
    
    private weak var from: UIViewController?
    
    private let completion: (() -> Void)
    
    private var testVC: TestViewController?
    private var testStatsVC: TestStatsViewController?
    
    init(testTypes: [TestType], course: Course, isTopicTest: Bool, from: UIViewController?, completion: @escaping (() -> Void)) {
        self.testTypes = testTypes
        self.course = course
        self.isTopicTest = isTopicTest
        
        self.from = from
        
        self.completion = completion
    }
}

// MARK: Public
extension TestSequence {
    func start() {
        guard !testTypes.isEmpty else {
            completion()
            return
        }
        
        let testType = testTypes.removeFirst()
        
        testVC = TestViewController.make(course: course, testType: testType, isTopicTest: isTopicTest)
        testVC?.delegate = self
        from?.present(testVC!, animated: true)
    }
}

// MARK: TestViewControllerDelegate
extension TestSequence: TestViewControllerDelegate {
    func testViewControllerDismiss() {
        testVC?.dismiss(animated: true) { [weak self] in
            self?.completion()
        }
    }
    
    func testViewControllerClose(finish: TestFinishElement) {
        testVC?.dismiss(animated: true) { [weak self] in
            TestCloseMediator.shared.notifyAboudTestClosed(with: finish)
            
            self?.completion()
        }
    }
    
    func testViewControllerNeedPayment() {
        testVC?.dismiss(animated: true) { [weak self] in
            let rootVC = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
            rootVC?.present(PaygateViewController.make(), animated: true)
            
            self?.completion()
        }
    }
    
    func testViewController(finish: TestFinishElement) {
        testStatsVC = TestStatsViewController.make(userTestId: finish.userTestId,
                                                   testType: finish.testType,
                                                   isEnableNext: !testTypes.isEmpty,
                                                   isTopicTest: finish.isTopicTest)
        testStatsVC?.delegate = self

        testVC?.dismiss(animated: true) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.from?.present(self.testStatsVC!, animated: true)
        }
    }
}

// MARK: TestStatsViewControllerDelegate
extension TestSequence: TestStatsViewControllerDelegate {
    func testStatsViewControllerDidTapped(event: TestStatsViewController.Event) {
        testStatsVC?.dismiss(animated: true) { [weak self] in
            guard let self = self else {
                return
            }

            switch event {
            case .close:
                self.completion()
            case .restart(let userTestId):
                if let testVC = self.testVC {
                    self.from?.present(testVC, animated: true) {
                        testVC.restart(userTestId: userTestId)
                    }
                }
            case .nextTest:
                self.testVC = nil
                self.start()
            }
        }
        testStatsVC = nil
    }
}
