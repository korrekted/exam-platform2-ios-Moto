//
//  GetCountriesResponse.swift
//  CDL
//
//  Created by Andrey Chernyshev on 25.05.2021.
//

final class GetCountriesResponseMapper {
    static func map(from response: Any) -> [Country] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let countriesArray = data["countries"] as? [[String: Any]]
        else {
            return []
        }
        
        return countriesArray.compactMap { countryJSON -> Country? in
            guard
                let name = countryJSON["name"] as? String,
                let code = countryJSON["code"] as? String,
                let preSelected = countryJSON["selected"] as? Bool,
                let sort = countryJSON["sort"] as? Int
            else {
                return nil
            }
            
            let languagesArray = countryJSON["languages"] as? [[String: Any]] ?? []
            let languages = map(languagesArray: languagesArray)
            
            return Country(name: name,
                           code: code,
                           preSelected: preSelected,
                           sort: sort,
                           languages: languages)
        }
    }
}

// MARK: Private
private extension GetCountriesResponseMapper {
    static func map(languagesArray: [[String: Any]]) -> [Language] {
        return languagesArray.compactMap { languageJSON -> Language? in
            guard
                let name = languageJSON["name"] as? String,
                let code = languageJSON["code"] as? String,
                let preSelected = languageJSON["selected"] as? Bool,
                let sort = languageJSON["sort"] as? Int
            else {
                return nil
            }
            
            let statesArray = languageJSON["states"] as? [[String: Any]] ?? []
            let states = map(statesArray: statesArray)
            
            return Language(name: name,
                            code: code,
                            preSelected: preSelected,
                            sort: sort,
                            states: states)
        }
    }
    
    static func map(statesArray: [[String: Any]]) -> [State] {
        return statesArray.compactMap { stateJSON -> State? in
            guard
                let name = stateJSON["name"] as? String,
                let code = stateJSON["code"] as? String,
                let sort = stateJSON["sort"] as? Int
            else {
                return nil
            }
            
            return State(name: name,
                         code: code,
                         sort: sort)
        }
    }
}
