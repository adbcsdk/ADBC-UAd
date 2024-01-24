//
//  File.swift
//  
//
//  Created by 신아람 on 1/11/24.
//

import Foundation
import AdSupport
import GoogleMobileAds
import AppTrackingTransparency

public typealias UAdInitHandler = (UAdInitStatusCode) -> Void
public enum UAdInitStatusCode {
    case success
    case noData
    case noAdid
    case fail
}

open class UAdMobileAds {
    
    private static var _instance: UAdMobileAds {
        let instance = UAdMobileAds()
        return instance
    }
    
    private var isDebug = false
    private var isTracking = false
    private var isLoading = false
    private var hand: UAdInitHandler?
    
    open class func shared() -> UAdMobileAds {
        return _instance
    }
    
    private init() {
    }
    
    public func initialize(appID: String, userID: String, isDebug: Bool) {
        UserInfo.shared.appCode = appID
        UserInfo.shared.userID = userID
        self.isDebug = isDebug
        
        GADMobileAds.sharedInstance().start { status in
            
            let adapterStatuses = status.adapterStatusesByClassName
            for adapter in adapterStatuses {
                let adapterStatus = adapter.value
                
                print("Adapter Name: \(adapter.key), Description: \(adapterStatus.description), Latency: \(adapterStatus.latency)")
            }
            
        }
        
        getSetting()
    }
    
    public func setData(completion: UAdInitHandler?) {
        self.hand = completion
    }
    
    private func getSetting() {

        if isLoading { return }
        Task {
            do {
                isLoading = true
                
                setIDFAAndRegistDevice()
                
//                print("GADMobileAds.version = \(GADMobileAds.sharedInstance().versionNumber)")
//                print("UnityAds.version = \(UnityAds.getVersion())")
//                print("FBAudienceNetworkAds.version = \(FBAdSettings.version())")
//                print("ALSdk.version = \(ALSdk.version())")
//                
//                let frameworkBundle = Bundle(for: FBAdView.self)
//                if let version = frameworkBundle.infoDictionary?["CFBundleShortVersionString"] as? String {
//                    print("FBAudienceNetworkAds 버전: \(version)")
//                } else {
//                    print("FBAudienceNetworkAds 버전을 가져올 수 없습니다.")
//                }
//                
//                if let path = Bundle.main.path(forResource: "Package", ofType: "swift"),
//                    let content = try? String(contentsOfFile: path),
//                    let versionRange = content.range(of: #"\.package\(.*"AdsGlobalPackage", from: "(.*?)".*\)"#, options: .regularExpression),
//                    let version = String(content[versionRange]).components(separatedBy: "\"").dropFirst().first {
//                    print("AdsGlobalPackage 버전: \(version)")
//                } else {
//                    print("AdsGlobalPackage fail")
//                }
                
                
                let param = SettingParam(adtracking: isTracking, version: getVersion())
                print("data = \(param.dictionary)")

                let result: Setting = try await NetworkManager.shared.request(subURL: "setting.html", params: param.dictionary, method: .get)
                
                if let debug = Bool(result.data.debug) {
                    UserInfo.shared.isDebug = (debug || isDebug)
                } else {
                    UserInfo.shared.isDebug = isDebug
                }
                
                if let ump = Bool(result.data.ump) {
                    UserInfo.shared.ump = ump
                }
                UserInfo.shared.adCodes = result.data.ads
                
                isLoading = false
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
    }
    
    private func getVersion() -> String {
        
        let versionNumber = GADMobileAds.sharedInstance().versionNumber
        let gAdVer = "\(versionNumber.majorVersion).\(versionNumber.minorVersion).\(versionNumber.patchVersion)"
        
//        let versionInfo = VersionInfo(sdkVer: "1.0.0", originVer: gAdVer, mediations: VersionInfo.Mediations(applovin: ALSdk.version(), pangle: "5.5.0.7", unityads: UnityAds.getVersion(), meta: "6.14.0"))
        
        let versionInfo = VersionInfo(sdkVer: "1.0.0", originVer: gAdVer, mediations: VersionInfo.Mediations(applovin: "", pangle: "", unityads: "", meta: ""))

        do {
            let jsonData = try JSONEncoder().encode(versionInfo)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                return jsonString
            }
            return ""
            
        } catch {
            print(error)
            return ""
        }
    }
    
    private func setIDFAAndRegistDevice() {
        let vm = TrackingViewModel()
        let status = ATTrackingManager.trackingAuthorizationStatus
        UserInfo.shared.idfa = ""
        if status == .authorized {
            isTracking = true
            UserInfo.shared.idfa = vm.getIDFAStr()
        } else {
            isTracking = false
        }
    }
}
