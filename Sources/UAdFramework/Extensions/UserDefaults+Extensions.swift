//
//  UserDefaults+Extensions.swift
//
//  Created by 신아람 on 1/11/24.
//

import UIKit

extension UserDefaults {
    struct Key<Value> {
        let name: String
        init(_ name: String) {
            self.name = name
        }
    }
    
    subscript<V: Codable>(key: Key<V>) -> V? {
        get {
            guard let data = self.data(forKey: key.name) else {
                return nil
            }
            return try? JSONDecoder().decode(V.self, from: data)
        }
        set {
            guard let value = newValue, let data = try? JSONEncoder().encode(value) else {
                self.set(nil, forKey: key.name)
                return
            }
            self.set(data, forKey: key.name)
        }
    }
    
    subscript(key: Key<Date>) -> Date? {
        get { return self.object(forKey: key.name) as? Date }
        set { self.set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<String>) -> String? {
        get { return self.string(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<Data>) -> Data? {
        get { return self.data(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<Bool>) -> Bool {
        get { return self.bool(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<Int>) -> Int {
        get { return self.integer(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<Float>) -> Float {
        get { return self.float(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<Double>) -> Double {
        get { return self.double(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }
    
    /// UserDefault 전체를 프린트하는 함수
    func printAllUserDefaults() {
        print("--------- UAD_SDK LIST BEGIN ----------")
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) : \(value)")
        }
        print("---------- UAD_SDK List END -----------")
    }
}


extension UserDefaults.Key {
    typealias Key = UserDefaults.Key
    
    static var appCode: Key<String> {
        return Key<String>("UAD_SDK_KEY_APPCODE")
    }
    static var userID: Key<String> {
        return Key<String>("UAD_SDK_KEY_USERID")
    }
    static var idfa: Key<String> {
        return Key<String>("UAD_SDK_KEY_IDFA")
    }
    static var isDebug: Key<Bool> {
        return Key<Bool>("UAD_SDK_KEY_IS_DEBUG")
    }
    static var ump: Key<Bool> {
        return Key<Bool>("UAD_SDK_KEY_UMP")
    }
    static var privacyUsagePermission: Key<Bool> {
        return Key<Bool>("UAD_SDK_KEY_PERMISSION_FOR_PRIVACY_USAGE")
    }
    static var adCodes: Key<Data> {
        return Key<Data>("UAD_SDK_KEY_AD_CODES")
    }
    
    static var closePopupDate: Key<Date> {
        return Key<Date>("UAD_SDK_KEY_CLOSE_POPUP_DATE")
    }
    
    static var idfaPopupShowDate: Key<Date> {
        return Key<Date>("UAD_SDK_POPUP_SHOW_DATE")
    }
}
