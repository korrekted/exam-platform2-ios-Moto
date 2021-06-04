//
//  GetBriefResponseMapper.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 15.02.2021.
//

final class GetBriefResponseMapper {
    static func from(response: Any) -> Brief? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any]
        else {
            return nil
        }
        
        guard
            let streak = data["streak"] as? Int,
            let calendar = data["calendar"] as? [Bool]
        else {
            return nil
        }
        
        return Brief(streak: streak,
                     calendar: calendar)
    }
}
