//
//  UAdMobileAds.swift
//
//  Created by 신아람 on 1/11/24.
//

import AdSupport
import GoogleMobileAds
import AppTrackingTransparency
import UserMessagingPlatform
import Foundation

#if canImport(PAGAdSDK)
import PAGAdSDK
#endif


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
    
    var onResultInitialize: ((Bool, String) -> Void)?
    
    open class func shared() -> UAdMobileAds {
        return _instance
    }
    
    private init() {
    }
    
    public func initialize(appID: String, userID: String, isDebug: Bool, completion: ((Bool, String) -> Void)?) {
        UserInfo.shared.appCode = appID
        UserInfo.shared.userID = userID
        self.isDebug = isDebug
        
        getSetting(completion: completion)
    }
    
    public func setData(completion: UAdInitHandler?) {
        self.hand = completion
    }
    
    private func getSetting(completion: ((Bool, String) -> Void)?) {

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
                
                
                let param = SettingParam(adtracking: isTracking, version: getVersion())
                let result: Setting = try await NetworkManager.shared.request(subURL: "setting.html", params: param.dictionary, method: .get)
                
                isLoading = false
                
                if let debug = Bool(result.data.debug) {
                    UserInfo.shared.isDebug = (debug || isDebug)
                } else {
                    UserInfo.shared.isDebug = isDebug
                }
                
                if let ump = Bool(result.data.ump) {
                    UserInfo.shared.ump = ump
                    
                    if(true) {
                        DispatchQueue.main.async {
                            self.updateUIViewController()
                        }
                    } else {
                        await GADMobileAds.sharedInstance().start()
                    }
                }
                UserInfo.shared.adCodes = result.data.ads
                
                if let completion = completion {
                    completion(true, "")
                }
                
            } catch let error {
                print(error.localizedDescription)
                if let completion = completion {
                    completion(false, error.localizedDescription)
                }
            }
        }
        
    }
    
    private func getVersion() -> String {
        
        let versionNumber = GADMobileAds.sharedInstance().versionNumber
        let gAdVer = "\(versionNumber.majorVersion).\(versionNumber.minorVersion).\(versionNumber.patchVersion)"
        
//        let versionInfo = VersionInfo(sdkVer: "1.0.0", originVer: gAdVer, mediations: VersionInfo.Mediations(applovin: ALSdk.version(), pangle: "5.5.0.7", unityads: UnityAds.getVersion(), meta: "6.14.0"))
        
        var pangleVer = ""
        #if canImport(PAGAdSDK)
        pangleVer = PAGSdk.sdkVersion
        #endif
        
        let versionInfo = VersionInfo(sdkVer: "1.0.0", originVer: gAdVer, mediations: VersionInfo.Mediations(applovin: "", pangle: pangleVer, unityads: "", meta: ""))

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
    
    private func updateUIViewController() {
        
        DispatchQueue.main.async {
            
            var uiViewController = UIApplication.getMostTopViewController()!
            
            UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: nil) {requestConsentError in
                if let consentError = requestConsentError { // 요청 실패
                    print("Error: \(consentError.localizedDescription)")
                    return
                }
                            
                UMPConsentForm.loadAndPresentIfRequired(from: uiViewController ) {loadAndPresentError in
                    if let consentError = loadAndPresentError { // 팝업창 표시 실패
                        print("Error: \(consentError.localizedDescription)")
                        return
                    }

                    if UMPConsentInformation.sharedInstance.canRequestAds {
                        GADMobileAds.sharedInstance().start()
                    }
                }
            }
        }
    }
}
