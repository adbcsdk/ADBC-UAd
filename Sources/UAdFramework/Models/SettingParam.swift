//
//  SettingParam.swift
//  
//
//  Created by 신아람 on 1/11/24.
//

import Foundation

class SettingParam : Device {
    var adtracking: Bool
    var platform: String?
    var version: String?
    
    private enum CodingKeys : String, CodingKey {
        case platform, version
        case appid = "appId"
        case adtracking = "ad_tracking"
        case appuid = "app_uid"
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(adtracking, forKey: .adtracking)
        try container.encode(platform, forKey: .platform)
        try container.encode(version, forKey: .version)
        try super.encode(to: encoder)
    }
    
    init(adtracking: Bool, version: String) {
        self.adtracking = adtracking
        self.platform = "ios"
        self.version = version
        super.init()
    }
}

struct Setting : Decodable {
    var data: Setting
    
    private enum CodingKeys : String, CodingKey {
        case data
    }
    
    struct Setting : Decodable {
        var ump: String
        var debug: String
        var ads: [Ad]
        
        private enum CodingKeys : String, CodingKey {
            case ump, debug, ads
        }
    }
    
    struct Ad : Decodable {
        var zone: String
        var network: String
        var type: String
        var code: String
        
        private enum CodingKeys : String, CodingKey {
            case zone, network, type, code
        }
    }
}

struct VersionInfo: Encodable {
    var sdkVer: String
    var originVer: String
    var mediations: Mediations
    
    struct Mediations: Encodable {
        var applovin: String
        var pangle: String
        var unityads: String
        var meta: String
    }
}
