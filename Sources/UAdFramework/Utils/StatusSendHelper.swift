//
//  File.swift
//  
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
    
    func sendStatus(adsType: String, status: UAdStatusCode, resInfo: GADResponseInfo?) {

        if let info = resInfo {
            aa(resInfo: info)
        }
        
//        if isLoading { return }
//        Task {
//            do {
//                isLoading = true
//                
//                let param = StatusParam(sessionId: sessionID.uuidString, type: adsType, size: "", status: status.rawValue, order: 0, mediation: <#T##String#>)
//                print("data = \(param.dictionary)")
//
//                let result: APIResult = try await NetworkManager.shared.request(subURL: "status.html", params: param.dictionary, method: .get)
//                
//                isLoading = false
//            } catch let error {
//                print(error.localizedDescription)
//            }
//        }
    }
    
    func aa(resInfo: GADResponseInfo) {
        
        
        if let medInfo = resInfo.responseIdentifier {
            print("Mediation Info: \(medInfo)")
        } else {
            print("No Mediation Info")
        }
        
        if !resInfo.adNetworkInfoArray.isEmpty {
                for adNetworkInfo in resInfo.adNetworkInfoArray {
                    print("Ad Network Class Name: \(adNetworkInfo.adNetworkClassName ?? "Unknown")")
                    // 추가 정보 출력
                }
            } else {
                print("Ad Network Info Array is empty.")
            }
        
    }
}
