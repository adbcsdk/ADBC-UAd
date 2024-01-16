//
//  File.swift
//  
//
//  Created by 신아람 on 1/16/24.
//

import Foundation

class StatusParam : Device {
    var sessionId: String
    var type: String?
    var size: String?
    var status: String?
    var order: Int?
    var mediation: String?
    
    private enum CodingKeys : String, CodingKey {
        case type, size, status, order, mediation
        case sessionId = "sessionid"
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sessionId, forKey: .sessionId)
        try container.encode(type, forKey: .type)
        try container.encode(size, forKey: .size)
        try container.encode(status, forKey: .status)
        try container.encode(order, forKey: .order)
        try container.encode(mediation, forKey: .mediation)
        try super.encode(to: encoder)
    }
    
    init(sessionId: String, type: String, size: String, status: String, order: Int, mediation: String) {
        self.sessionId = sessionId
        self.type = type
        self.size = size
        self.status = status
        self.order = order
        self.mediation = mediation
        super.init()
    }
}
