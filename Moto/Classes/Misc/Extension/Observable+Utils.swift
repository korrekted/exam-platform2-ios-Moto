//
//  Observable+Utils.swift
//  DMV
//
//  Created by Андрей Чернышев on 25.06.2022.
//

import RxSwift

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        map { _ -> Void in
            Void()
        }
    }
}
