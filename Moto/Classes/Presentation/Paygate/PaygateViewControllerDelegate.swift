//
//  PaygateViewControllerDelegate.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 08.07.2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

enum PaygateViewControllerResult {
    case bied, restored, cancelled
}

protocol PaygateViewControllerDelegate: AnyObject {
    func paygateDidClosed(with result: PaygateViewControllerResult)
}

extension PaygateViewControllerDelegate {
    func paygateDidClosed(with result: PaygateViewControllerResult) {}
}
