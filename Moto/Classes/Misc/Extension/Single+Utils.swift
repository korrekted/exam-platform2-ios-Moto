//
//  Single+Utils.swift
//  Moto
//
//  Created by Андрей Чернышев on 25.06.2022.
//

import RxSwift

extension PrimitiveSequenceType where Trait == SingleTrait {
    func mapToVoid() -> Single<Void> {
        map { _ -> Void in
            Void()
        }
    }
}
