//
//  StatsShareManager.swift
//  CDL
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import Foundation

final class StatsShareManager {
    static let shared = StatsShareManager()
    
    private init() {}
}

// MARK: Public
extension StatsShareManager {
    func sharedContainerURL() -> URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.moto.widgets")
    }
    
    @discardableResult
    func write(stats: Stats) -> Bool {
        guard let url = sharedContainerURL()?.appendingPathComponent("stats.json") else {
            return false
        }
        
        guard let data = try? JSONEncoder().encode(stats) else {
            return false
        }
        
        do {
            try data.write(to: url)
        } catch {
            return false
        }
        
        return true
    }
    
    func read() -> Stats? {
        guard let url = sharedContainerURL()?.appendingPathComponent("stats.json") else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        
        return try? JSONDecoder().decode(Stats.self, from: data)
    }
}
