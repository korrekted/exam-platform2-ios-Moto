//
//  SessionManagerCore.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxCocoa

final class SessionManagerCore: SessionManager {
    struct Constants {
        static let sessionCacheKey = "session_manage_core_session_cache_key"
    }
}

// MARK: API
extension SessionManagerCore {
    func store(session: Session) {
        guard let data = try? JSONEncoder().encode(session) else {
            return
        }
        
        UserDefaults.standard.setValue(data, forKey: Constants.sessionCacheKey)
    }
    
    func set(userToken: String) {
        let session: Session
        
        if let cachedSession = getSession() {
            session = Session(userId: cachedSession.userId,
                              userToken: userToken,
                              activeSubscription: cachedSession.activeSubscription)
        } else {
            session = Session(userId: nil,
                              userToken: userToken,
                              activeSubscription: false)
        }
        
        store(session: session)
    }
    
    func getSession() -> Session? {
        guard
            let data = UserDefaults.standard.data(forKey: Constants.sessionCacheKey),
            let session = try? JSONDecoder().decode(Session.self, from: data)
        else {
            return nil
        }
        
        return session
    }
}
