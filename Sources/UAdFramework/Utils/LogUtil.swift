//
//  LogUtil.swift
//
//  Created by 신아람 on 2/1/24.
//

class LogUtil {
    
    static let shared = LogUtil()
    
    enum LogLevel {
        case debug
        case error
    }
    
    private init() {}
    
    func log(_ level: LogLevel, msg: String) {
        
        if UserInfo.shared.isDebug {
            let prefix: String
            switch level {
            case .debug:
                prefix = "[DEBUG]"
            case .error:
                prefix = "[ERROR]"
            }

            print("\(prefix) \(msg)")
        }
    }
}
