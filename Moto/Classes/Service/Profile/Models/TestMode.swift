//
//  TestMode.swift
//  CDL
//
//  Created by Andrey Chernyshev on 03.07.2021.
//

enum TestMode: Int, Codable {
    case noExplanations, fullComplect, onAnExam
}

// MARK: Public
extension TestMode {
    init?(code: Int) {
        switch code {
        case 0:
            self = .fullComplect
        case 1:
            self = .noExplanations
        case 2:
            self = .onAnExam
        default:
            return nil
        }
    }
    
    func code() -> Int {
        switch self {
        case .fullComplect:
            return 0
        case .noExplanations:
            return 1
        case .onAnExam:
            return 2
        }
    }
}
