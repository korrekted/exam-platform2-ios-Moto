//
//  SetRequest.swift
//  CDL
//
//  Created by Andrey Chernyshev on 28.04.2021.
//

import Alamofire

struct SetRequest: APIRequestBody {
    private let userToken: String
    private let country: String?
    private let state: String?
    private let language: String?
    private let selectedCoursesIds: [Int]?
    private let selectedCourseId: Int?
    private let level: Int?
    private let assetsPreferences: [Int]?
    private let testMode: Int?
    private let examDate: String?
    private let testMinutes: Int?
    private let testNumber: Int?
    private let testWhen: [Int]?
    private let notificationKey: String?
    
    init(userToken: String,
         country: String? = nil,
         state: String? = nil,
         language: String? = nil,
         selectedCoursesIds: [Int]? = nil,
         selectedCourseId: Int? = nil,
         level: Int? = nil,
         assetsPreferences: [Int]? = nil,
         testMode: Int? = nil,
         examDate: String? = nil,
         testMinutes: Int? = nil,
         testNumber: Int? = nil,
         testWhen: [Int]? = nil,
         notificationKey: String? = nil) {
        self.userToken = userToken
        self.country = country
        self.state = state
        self.language = language
        self.selectedCoursesIds = selectedCoursesIds
        self.selectedCourseId = selectedCourseId
        self.level = level
        self.assetsPreferences = assetsPreferences
        self.testMode = testMode
        self.examDate = examDate
        self.testMinutes = testMinutes
        self.testNumber = testNumber
        self.testWhen = testWhen
        self.notificationKey = notificationKey
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/users/set"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: [String: Any] = [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken
        ]
        
        if let country = self.country {
            params["country"] = country
        }
        
        if let state = self.state {
            params["state"] = state
        }
        
        if let language = self.language {
            params["language"] = language
        }
        
        if let selectedCoursesIds = self.selectedCoursesIds {
            params["course_ids"] = selectedCoursesIds
        }
        
        if let selectedCourseId = self.selectedCourseId {
            params["current_application_course_id"] = selectedCourseId
        }
        
        if let level = self.level {
            params["level"] = level
        }
        
        if let assetsPreferences = self.assetsPreferences {
            params["assets_preferences"] = assetsPreferences
        }
        
        if let testMode = self.testMode {
            params["test_mode"] = testMode
        }
        
        if let examDate = self.examDate {
            params["exam_date"] = examDate
        }
        
        if let testMinutes = self.testMinutes {
            params["test_minutes"] = testMinutes
        }
        
        if let testNumber = self.testNumber {
            params["test_number"] = testNumber
        }
        
        if let testWhen = self.testWhen {
            params["test_when"] = testWhen
        }
        
        if let notificationKey = self.notificationKey {
            params["notification_key"] = notificationKey
        }
        
        return params
    }
}
