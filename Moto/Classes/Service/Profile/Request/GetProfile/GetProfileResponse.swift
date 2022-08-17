//
//  GetProfileResponse.swift
//  CDL
//
//  Created by Андрей Чернышев on 16.08.2022.
//

final class GetProfileResponse {
    static func map(from response: Any) -> Profile? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any]
        else {
            return nil
        }
        
        let selectedCoursesIds = data["selected_application_courses"] as? [Int]
        let selectedCourse = selectedCourse(data)
        let locale = locale(data)
        let testMode = testMode(data)
        
        return Profile(selectedCoursesIds: selectedCoursesIds ?? [],
                       selectedCourse: selectedCourse,
                       locale: locale,
                       testMode: testMode)
    }
}

// MARK: Private
private extension GetProfileResponse {
    static func selectedCourse(_ json: [String: Any]) -> Course? {
        guard
            let courseJSON = json["current_course"] as? [String: Any],
            let id = courseJSON["id"] as? Int,
            let name = courseJSON["name"] as? String,
            let subTitle = courseJSON["sub"] as? String,
            let isMain = courseJSON["main"] as? Bool,
            let sort = courseJSON["sort"] as? Int
        else {
            return nil
        }
        
        return Course(id: id,
                      name: name,
                      subTitle: subTitle,
                      isMain: isMain,
                      sort: sort,
                      progress: 0,
                      testCount: 0,
                      selected: true)
    }
    
    static func testMode(_ json: [String: Any]) -> TestMode? {
        guard let testModeCode = json["test_mode"] as? Int else {
            return nil
        }
        
        return TestMode(code: testModeCode)
    }
    
    static func locale(_ json: [String: Any]) -> ProfileLocale? {
        ProfileLocale(countryCode: json["country"] as? String,
                      languageCode: json["language"] as? String,
                      stateCode: json["state"] as? String)
    }
}
