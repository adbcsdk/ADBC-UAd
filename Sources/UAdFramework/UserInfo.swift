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
    
    var isDebug: Bool? {
        get {
            return UserDefaults.standard[.isDebug]
        }
        set(newIsDebug) {
            if let isDebug = newIsDebug {
                UserDefaults.standard[.isDebug] = isDebug
            }
        }
    }
    
    var ump: Bool? {
        get {
            return UserDefaults.standard[.ump]
        }
        set(newUmp) {
            if let ump = newUmp {
                UserDefaults.standard[.ump] = ump
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
    
    var adCodes: [Setting.Ad] {
        get {
            if let data = UserDefaults.standard[.adCodes] {
                do {
                    let decoder = JSONDecoder()
                    let storedAds = try decoder.decode([Setting.Ad].self, from: data)
                    print(storedAds)
                    return storedAds
                } catch {
                    print("Error decoding ads: \(error.localizedDescription)")
                    return []
                }
            } else {
                return []
            }
        }
        set(newCodes) {
            if(newCodes.count > 0) {
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(newCodes)
                    UserDefaults.standard[.adCodes] = data
                } catch {
                    print("Error encoding ads: \(error.localizedDescription)")
                }
            }
        }
    }
    
    public func getAdUnitId(zoneId: String) -> Setting.Ad? {
        return UserInfo.shared.adCodes.first(where: { $0.zone == zoneId })
    }
}
