//
//  ObservableRetrySingle.swift
//  Moto
//
//  Created by Андрей Чернышев on 20.05.2022.
//

import RxSwift

final class ObservableRetrySingle {
    private lazy var disposeBag = DisposeBag()
    
    func retry<SourceType, TriggerType>(source: @escaping () -> (PrimitiveSequence<SingleTrait, SourceType>),
                                        trigger: @escaping (Error) -> (Observable<TriggerType>)) -> Observable<SourceType> {
        Observable<SourceType>
            .create { [weak self] observe in
                guard let self = self else {
                    observe.onCompleted()
                    return Disposables.create()
                }
                
                source().subscribe(onSuccess: { element in
                    observe.onNext(element)
                }, onFailure: { error in
                    observe.onError(error)
                }, onDisposed: {
                    observe.onCompleted()
                })
                .disposed(by: self.disposeBag)
            
                return Disposables.create()
            }
            .retry(when: { errorObs in
                errorObs.flatMap { error in
                    trigger(error)
                }
            })
    }
}
