//
//  File 2.swift
//  
//
//  Created by 신아람 on 1/11/24.
//

import Foundation
import AdSupport
import UIKit

class UserInfo {
    static let shared: UserInfo = {
        let instance = UserInfo()
        return instance
    }()
    
    var uuidStr: String
    
    init() {
        uuidStr = UIDevice.current.identifierForVendor?.uuidString ?? "NULL"
    }
    
    var appCode: String? {
        get {
            return UserDefaults.standard[.appCode]
        }
        set(newAppCode) {
            if let code = newAppCode {
                UserDefaults.standard[.appCode] = code
            }
        }
    }
    
    var userID: String? {
        get {
            return UserDefaults.standard[.userID]
        }
        set(newUserID) {
            if let id = newUserID {
                UserDefaults.standard[.userID] = id
            }
        }
    }
    
    var idfa: String? {
        get {
            return UserDefaults.standard[.idfa]
        }
        set(newIDFA) {
            if let idfa = newIDFA {
                UserDefaults.standard[.idfa] = idfa
            }
        }
    }
    
    var isTest: Bool? {
        get {
            return UserDefaults.standard[.isTest]
        }
        set(newIsTest) {
            if let isTest = newIsTest {
                UserDefaults.standard[.isTest] = isTest
            }
        }
    }
    
    var modelStr : String {
        get {
            if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
            var sysinfo = utsname()
            uname(&sysinfo) // ignore return value
            return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        }
    }
    
    var isPermitted: Bool {
        get {
            return UserDefaults.standard[.privacyUsagePermission]
        }
        set(flag) {
            UserDefaults.standard[.privacyUsagePermission] = flag
        }
    }
}
