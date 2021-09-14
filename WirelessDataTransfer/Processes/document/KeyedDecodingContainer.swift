//
//  KeyedDecodingContainer.swift
//  ZuTapp
//
//  Created by Joe Lewis on 26/7/21.
//

import Foundation

extension KeyedDecodingContainer{
    public func decodeBoolAndIntToBool(key: KeyedDecodingContainer<K>.Key) -> Bool{
        do {
            return try self.decode(Bool.self, forKey: key)
        } catch DecodingError.typeMismatch {
            do {
                return try self.decode(Int.self, forKey: key) == 1
            } catch {
                return false
            }
        } catch{
            return false
        }
    }
}
