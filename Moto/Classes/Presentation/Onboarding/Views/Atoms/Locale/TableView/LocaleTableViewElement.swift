//
//  LocaleTableViewElement.swift
//  CDL
//
//  Created by Andrey Chernyshev on 25.05.2021.
//

final class LocaleTableViewElement {
    var isSelected: Bool
    let name: String
    let code: String
    
    init(isSelected: Bool,
         name: String,
         code: String) {
        self.isSelected = isSelected
        self.name = name
        self.code = code
    }
}
