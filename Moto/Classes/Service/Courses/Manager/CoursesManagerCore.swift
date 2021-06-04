//
//  CoursesManagerCore.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift

final class CoursesManagerCore: CoursesManager {
    struct Constants {
        static let selectedCourseCacheKey = "courses_manager_core_selected_course_cache_key"
    }
}

// MARK: API
extension CoursesManagerCore {
    func select(course: Course) {
        guard let data = try? JSONEncoder().encode(course) else {
            return
        }
        
        UserDefaults.standard.set(data, forKey: Constants.selectedCourseCacheKey)
    }
    
    func getSelectedCourse() -> Course? {
        guard let data = UserDefaults.standard.data(forKey: Constants.selectedCourseCacheKey) else {
            return nil
        }
        
        return try? JSONDecoder().decode(Course.self, from: data)
    }
}

// MARK: API(Rx)
extension CoursesManagerCore {
    func retrieveCourses() -> Single<[Course]> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .deferred { .just([]) }
        }
        
        let request = GetCourcesRequest(userToken: userToken)
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map(GetCourcesResponseMapper.map(from:))
    }
    
    func rxSelect(course: Course) -> Single<Void> {
        Single<Void>
            .create { [weak self] event in
                self?.select(course: course)
                
                event(.success(Void()))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func rxGetSelectedCourse() -> Single<Course?> {
        Single<Course?>
            .create { [weak self] event in
                let selectedCourse = self?.getSelectedCourse()
                
                event(.success(selectedCourse))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
}
