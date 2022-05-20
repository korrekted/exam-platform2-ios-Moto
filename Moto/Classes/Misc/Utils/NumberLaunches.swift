//
//  NumberLaunches.swift
//  Moto
//
//  Created by Андрей Чернышев on 20.05.2022.
//

import Foundation

final class NumberLaunches {
    struct Constants {
        static let countLaunchKey = "number_launches_key"
    }
    
    @discardableResult
    func launch() -> Self {
        var count = UserDefaults.standard.integer(forKey: Constants.countLaunchKey)
        
        if count <= (Int.max - 1) {
            count += 1
        }
        
        UserDefaults.standard.set(count, forKey: Constants.countLaunchKey)
        
        return self
    }
    
    func isFirstLaunch() -> Bool {
        UserDefaults.standard.integer(forKey: Constants.countLaunchKey) == 1
    }
}
