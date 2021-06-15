//
//  SessionManager.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxCocoa

protocol SessionManager: AnyObject {
    // MARK: API
    func store(session: Session)
    func set(userToken: String)
    func getSession() -> Session?
}
