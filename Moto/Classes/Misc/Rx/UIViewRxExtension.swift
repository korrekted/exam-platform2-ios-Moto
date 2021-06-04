//
//  UIViewRxExtension.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    var keyboardHeight: Observable<CGFloat> {
        return Observable
            .from([
                NotificationCenter.default.rx
                    .notification(UIApplication.keyboardWillShowNotification)
                    .map { notification -> CGFloat in
                        return (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                    },
                
                NotificationCenter.default.rx
                    .notification(UIApplication.keyboardWillHideNotification)
                    .map { notification -> CGFloat in
                        return 0
                    }
            ])
            .merge()
            .distinctUntilChanged()
    }
    
    var hideKeyboardObserver: Binder<Void> {
        return Binder(base) { base, _ in
            base.endEditing(true)
        }
    }
}
