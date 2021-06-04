//
//  GetLocaleResponse.swift
//  CDL
//
//  Created by Andrey Chernyshev on 26.05.2021.
//

final class GetLocaleResponseMapper {
    static func map(from response: Any) -> ProfileLocale? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any]
        else {
            return nil
        }
        
        return ProfileLocale(countryCode: data["country"] as? String,
                             languageCode: data["language"] as? String,
                             stateCode: data["state"] as? String)
    }
}
