//
//  StatusSendHelper.swift
//  
//  Created by 신아람 on 1/16/24.
//

import Foundation
import GoogleMobileAds

enum UAdStatusCode: String {
    case req
    case load
    case show
    case close
    case fail
    case noad
}

enum UAdMediation: String {
    case defaul = "Default"
    case applovin = "Applovin"
    case pangle = "Pangle"
    case unity = "UnityAds"
    case meta = "Meta"
}

class StatusSendHelper {
    private let sessionID: UUID
    
    init() {
        sessionID = UUID()
    }
    
    private var isLoading = false
    
    func sendStatus(session: String, adsType: String, status: UAdStatusCode, resInfo: GADResponseInfo?) {
        
        if isLoading { return }
        
        var order = 0
        var mediationName = ""
        if let info = resInfo {
            mediationName = (info.loadedAdNetworkResponseInfo?.adSourceName)!
            for (index, adNetworkInfo) in info.adNetworkInfoArray.enumerated() {
                if(mediationName == adNetworkInfo.adSourceName) {
                    order = index
                    break;
                }
            }
        }
        
        let localOrder = order
        let localName = mediationName
        
        Task {
            do {
                isLoading = true
                
                let param = StatusParam(sessionId: sessionID.uuidString, type: adsType, size: "", status: status.rawValue, order: localOrder, mediation: localName)

                let result: APIResult = try await NetworkManager.shared.request(subURL: "status.html", params: param.dictionary, method: .get)
                
                isLoading = false
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
