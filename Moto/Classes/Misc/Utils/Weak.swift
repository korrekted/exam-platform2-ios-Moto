//
//  Weak.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

final class Weak<T> {
    weak private var value: AnyObject?
    
    var weak: T? {
        return value as? T
    }
    
    init<T: AnyObject>(_ value: T) {
        self.value = value
    }
}
