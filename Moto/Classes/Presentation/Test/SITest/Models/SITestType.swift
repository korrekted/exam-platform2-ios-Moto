//
//  SITestType.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 07.04.2021.
//

import Foundation

enum SITestType {
    case saved
    case incorrect
}

extension SITestType {
    var name: String {
        switch self {
        case .saved:
            return "Saved".localized
        case .incorrect:
            return "Incorrect".localized
        }
    }
}
