//
//  OModeCollectionElement.swift
//  CDL
//
//  Created by Andrey Chernyshev on 21.06.2021.
//

final class OModeCollectionElement {
    let title: String
    let subtitle: String
    let image: String
    let code: Int
    var isSelected: Bool
    
    init(title: String,
         subtitle: String,
         image: String,
         code: Int,
         isSelected: Bool) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.code = code
        self.isSelected = isSelected
    }
}
