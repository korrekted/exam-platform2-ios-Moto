//
//  GetCoursesResponseMapper.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

final class GetCourcesResponseMapper {
    static func map(from response: Any) -> [Course] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let courses = data["courses"] as? [[String: Any]]
        else {
            return []
        }
        
        return courses.compactMap { courseJSON -> Course? in
            guard
                let id = courseJSON["id"] as? Int,
                let name = courseJSON["name"] as? String,
                let subTitle = courseJSON["sub"] as? String,
                let isMain = courseJSON["main"] as? Bool,
                let sort = courseJSON["sort"] as? Int,
                let progress = courseJSON["progress"] as? Int,
                let testCount = courseJSON["tests"] as? Int
            else {
                return nil
            }
            
            return Course(id: id,
                          name: name,
                          subTitle: subTitle,
                          isMain: isMain,
                          sort: sort,
                          progress: progress,
                          testCount: testCount,
                          selected: courseJSON["selected"] as? Bool ?? false)
        }
    }
}
