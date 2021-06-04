//
//  MonetizationConfig.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.11.2020.
//

enum MonetizationConfig: String {
    case block
    case suggest
}

// MARK: Hashable
extension MonetizationConfig: Hashable {}
