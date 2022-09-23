//
//  XOREncryption.swift
//  DMV
//
//  Created by Андрей Чернышев on 14.02.2022.
//

import Foundation

final class XOREncryption {
    static func encryptDecrypt(_ input: String, key: String) -> String? {
        guard !input.isEmpty else {
            return nil
        }
        
        var decrypted = [UInt8]()
        
        let cypher = [UInt8](input.utf8)
        
        let setKey = [UInt8](key.utf8)
        let length = setKey.count
        
        for c in cypher.enumerated() {
            decrypted.append(c.element ^ setKey[c.offset % length])
        }
        
        return String(bytes: decrypted, encoding: .utf8)
    }
    
    static func toJSON(_ input: String, key: String) -> [String: Any]? {
        guard
            let encryptDecrypt = encryptDecrypt(input, key: key),
            let data = encryptDecrypt.data(using: .utf8)
        else {
            return nil
        }
        
        return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    }
}
