//
//  DictionaryExtension.swift
//  Shinagawa.Swift
//
//  Created by Kazuya Ueoka on 2017/01/22.
//  Copyright © 2017年 fromKK. All rights reserved.
//

import Foundation

extension Dictionary where Key: Hashable, Value: Any {
    func value<T>(with key: String) -> T? {
        for (keyIn, value) in self {
            if let keyIn = keyIn as? String, keyIn == key {
                return value as? T
            }
        }
        return nil
    }
    
    func intValue(with key: String) -> Int? {
        guard let value: Any = self.value(with: key) else { return nil }
        if let intValue: Int = value as? Int {
            return intValue
        }
        
        if let strValue: String = value as? String {
            return Int(strValue)
        }
        
        return nil
    }
    
    func floatValue(with key: String) -> Float? {
        guard let value: Any = self.value(with: key) else { return nil }
        if let floatValue: Float = value as? Float {
            return floatValue
        }
        
        if let strValue: String = value as? String {
            return Float(strValue)
        }
        
        return nil
    }
    
    func doubleValue(with key: String) -> Double? {
        guard let value: Any = self.value(with: key) else { return nil }
        if let doubleVlue: Double = value as? Double {
            return doubleVlue
        }
        
        if let strValue: String = value as? String {
            return Double(strValue)
        }
        
        return nil
    }
    
    func boolValue(with key: String) -> Bool? {
        guard let value: Any = self.value(with: key) else { return nil }
        if let boolValue: Bool = value as? Bool {
            return boolValue
        }
        
        if let intValue: Int = value as? Int {
            return 1 == intValue
        }
        
        if let strValue: String = value as? String {
            return strValue == "1" || strValue == "true"
        }
        
        return nil
    }
}
