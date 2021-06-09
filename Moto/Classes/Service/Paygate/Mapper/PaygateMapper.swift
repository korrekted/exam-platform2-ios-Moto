//
//  PaygateMapper.swift
//  Explore
//
//  Created by Andrey Chernyshev on 26.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Foundation.NSAttributedString
import UIKit.UIColor

final class PaygateMapper {
    typealias PaygateResponse = (json: [String: Any], paygate: Paygate, productsIds: [String])
    
    static func parse(response: Any, productsPrices: [ProductPrice]?) -> PaygateResponse? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any]
        else {
            return nil
        }
        
        guard let paygate = map(main: data, productsPrices: productsPrices) else {
            return nil
        }
        
        let productIds = getProductIds(mainJSON: data)
        
        return PaygateResponse(json, paygate, productIds)
    }
}

// MARK: Private
private extension PaygateMapper {
    static func map(main: [String: Any]?, productsPrices: [ProductPrice]?) -> Paygate? {
        guard let main = main else {
            return nil
        }
        
        let optionsJSONArray = (main["options"] as? [[String: Any]]) ?? []
        let options = optionsJSONArray.enumerated().compactMap { map(option: $1, productsPrices: productsPrices, index: $0) }
        
        return Paygate(options: options)
    }
    
    static func map(option: [String: Any], productsPrices: [ProductPrice]?, index: Int) -> PaygateOption? {
        guard
            let productId = option["product_id"] as? String
        else {
            return nil
        }
        
        let title = (option["title"] as? String)?
            .attributed(with: TextAttributes()
                .font(Fonts.SFProRounded.bold(size: 18.scale))
                .lineHeight(21.scale))
        
        let subCaption = (option["subcaption"] as? String)?
            .attributed(with: TextAttributes()
                .font(Fonts.SFProRounded.regular(size: 14.scale))
                .lineHeight(16.8.scale))
        
        let save = (option["save"] as? String)?
            .attributed(with: TextAttributes()
                .font(Fonts.SFProRounded.bold(size: 13.scale))
                .letterSpacing(-0.08.scale)
                .lineHeight(18.scale))
        
        guard let productPrice = productsPrices?.first(where: { $0.id == productId }) else {
            return PaygateOption(productId: productId,
                                 title: title,
                                 caption: nil,
                                 save: save,
                                 bottomLine: nil)
        }
        
        let div = option["div"] as? Int ?? 1
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = productPrice.priceLocale
        
        let priceDiv: Double = productPrice.priceValue / Double(div)
        let priceDivLocalized: String
        if priceDiv < 100 {
            formatter.maximumFractionDigits = 1
            priceDivLocalized = formatter.string(from: NSNumber(value: (priceDiv * 10).rounded() / 10)) ?? ""
        } else {
            formatter.maximumFractionDigits = 0
            priceDivLocalized = formatter.string(from: NSNumber(value: round(priceDiv))) ?? ""
        }
        
        formatter.maximumFractionDigits = productPrice.priceValue.truncatingRemainder(dividingBy: 1) > 0 ? 2 : 0
        let priceLocalized = formatter.string(from: NSNumber(value: productPrice.priceValue)) ?? ""
        
        let caption = (option["caption"] as? String)?
            .replacingOccurrences(of: "@price_div", with: priceDivLocalized)
            .replacingOccurrences(of: "@price", with: priceLocalized)
        let captionAttrs = NSMutableAttributedString(string: caption ?? "",
                                                     attributes: TextAttributes()
                                                        .font(Fonts.SFProRounded.regular(size: 14.scale))
                                                        .lineHeight(16.8.scale)
                                                        .dictionary)
        let captionPriceLocalizedRange = NSString(string: caption ?? "").range(of: priceLocalized)
        captionAttrs.addAttributes(TextAttributes()
                                    .font(index == 0 ? Fonts.SFProRounded.regular(size: 14.scale) : Fonts.SFProRounded.bold(size: 24.scale))
                                    .lineHeight(index == 0 ? 16.8.scale : 28.8.scale)
                                    .dictionary,
                                   range: captionPriceLocalizedRange)
        let captionPriceDivLocalizedRange = NSString(string: caption ?? "").range(of: priceDivLocalized)
        captionAttrs.addAttributes(TextAttributes()
                                    .font(index == 0 ? Fonts.SFProRounded.regular(size: 14.scale) : Fonts.SFProRounded.bold(size: 24.scale))
                                    .lineHeight(index == 0 ? 16.8.scale : 28.8.scale)
                                    .dictionary,
                                   range: captionPriceDivLocalizedRange)
        
        let bottomLine = (option["bottom_line"] as? String)?
            .replacingOccurrences(of: "@price_div", with: priceDivLocalized)
            .replacingOccurrences(of: "@price", with: priceLocalized)
        let bottomLineAttrs = NSMutableAttributedString(string: bottomLine ?? "",
                                                        attributes: TextAttributes()
                                                            .font(index == 0 ? Fonts.SFProRounded.bold(size: 24.scale) : Fonts.SFProRounded.regular(size: 14.scale))
                                                            .lineHeight(index == 0 ? 28.8.scale : 16.8.scale)
                                                            .dictionary)
        let bottomLinePriceLocalizedRange = NSString(string: bottomLine ?? "").range(of: priceLocalized)
        bottomLineAttrs.addAttributes(TextAttributes()
                                        .font(index == 0 ? Fonts.SFProRounded.bold(size: 24.scale) : Fonts.SFProRounded.regular(size: 14.scale))
                                        .dictionary,
                                   range: bottomLinePriceLocalizedRange)
        let bottomLinePriceDivLocalizedRange = NSString(string: bottomLine ?? "").range(of: priceDivLocalized)
        bottomLineAttrs.addAttributes(TextAttributes()
                                        .font(index == 0 ? Fonts.SFProRounded.bold(size: 24.scale) : Fonts.SFProRounded.regular(size: 14.scale))
                                        .dictionary,
                                   range: bottomLinePriceDivLocalizedRange)
        
        let bottomLineResult = NSMutableAttributedString()
        if index == 0 {
            bottomLineResult.append(captionAttrs)
            bottomLineResult.append(NSAttributedString(string: " "))
            bottomLineResult.append(subCaption ?? NSAttributedString())
        } else {
            bottomLineResult.append(bottomLineAttrs)
        }
        
        let captionResult = NSMutableAttributedString()
        if index == 0 {
            captionResult.append(bottomLineAttrs)
        } else {
            captionResult.append(captionAttrs)
        }
        
        return PaygateOption(productId: productId,
                             title: title,
                             caption: captionResult,
                             save: save,
                             bottomLine: bottomLineResult)
    }
    
    static func getProductIds(mainJSON: [String: Any]?) -> [String] {
        var ids = [String]()
        
        let optionsJSON = mainJSON?["options"] as? [[String: Any]] ?? []
        for optionJSON in optionsJSON {
            if let id = optionJSON["product_id"] as? String {
                ids.append(id)
            }
        }
        
        return ids
    }
}
