//
//  TestCoordinator.swift
//  Moto
//
//  Created by Андрей Чернышев on 25.06.2022.
//

import UIKit

final class TestCoordinator {
    static let shared = TestCoordinator()
    
    private var sequence: TestSequence?
    
    private init() {}
}

// MARK: Public
extension TestCoordinator {
    func start(testTypes: [TestType], course: Course, isTopicTest: Bool, from: UIViewController?) {
        sequence = TestSequence(testTypes: testTypes, course: course, isTopicTest: isTopicTest, from: from) { [weak self] in
            self?.sequence = nil
        }
        sequence?.start()
    }
}
