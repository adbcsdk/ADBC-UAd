//
//  File.swift
//
//  Created by 신아람 on 1/11/24.
//

import Foundation

class Device : Encodable {
    var appCode: String
    var userID: String
    var idfa: String
    var uuid: String
    
    private enum CodingKeys : String, CodingKey {
        case appCode = "appId"
        case userID = "app_uid"
        case idfa
        case uuid = "deviceid"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(appCode, forKey: .appCode)
        try container.encode(userID, forKey: .userID)
        try container.encode(idfa, forKey: .idfa)
        try container.encode(uuid, forKey: .uuid)
    }
    
    init() {
        self.appCode = UserInfo.shared.appCode ?? ""
        self.userID = UserInfo.shared.userID ?? ""
        self.idfa = UserInfo.shared.idfa ?? ""
        self.uuid = UserInfo.shared.uuidStr
    }
}
