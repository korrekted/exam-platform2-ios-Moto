//
//  GetMonetizationResponseMapper.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.11.2020.
//

final class GetMonetizationResponseMapper {
    static func map(from response: Any) -> MonetizationConfig? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let mode = data["mode"] as? Int
        else {
            return nil
        }

        switch mode {
        case 1:
            // без оплаты/подписки доступен бесплатный контент, пользователя нужно запустить в приложение
            return .suggest
        case 2:
            // без оплаты/подписки невозможно пройти далее онбординга
            return .block
        default:
            return nil
        }
    }
}
