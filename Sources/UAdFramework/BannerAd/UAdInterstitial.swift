//
//  UAdInterstitial.swift
//
//  Created by 신아람 on 1/15/24.
//

import UIKit
import GoogleMobileAds

public protocol UAdFullScreenDelegate : AnyObject {
    func onFullScreenLoaded()
    func onFullScreenClicked()
    func onFullScreenShow()
    func onFullScreenDismiss()
    func onFullScreenFailed(msg: String)
}

@objcMembers
public class UAdInterstitial: NSObject {
    
    private let adsType = "interstitial"
    private let sessionID: String
    private let status = StatusSendHelper()
    
    private var isLoaded = false
    private var adUnitID: String = "ca-app-pub-3940256099942544/4411468910"
    private var rootViewController: UIViewController
    private var delegate: UAdFullScreenDelegate?
    
    private var interstitial: GADInterstitialAd?
    
    public init(zoneId: String, rootViewController: UIViewController, delegate: UAdFullScreenDelegate?) {
        
        self.rootViewController = rootViewController
        self.delegate = delegate
        self.sessionID = UUID().uuidString
        
        if let ad = UserInfo.shared.adCodes.first(where: { $0.zone == zoneId }) {
            self.adUnitID = ad.code
        } else {
            self.adUnitID = ""
        }
    }
    
    public func load() {
        
        if(adUnitID.isEmpty) {
            delegate?.onFullScreenFailed(msg: "Zone Id not found")
            return
        }
        
        if isLoaded { return }
        status.sendStatus(session: sessionID, adsType: adsType, status: UAdStatusCode.req, resInfo: nil)
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: request, completionHandler: { [self] ad, error in
            
            if let error = error {
                LogUtil.shared.log(.debug, msg: "Failed to load interstitial ad with error: \(error.localizedDescription)")
                status.sendStatus(session: sessionID, adsType: self.adsType, status: UAdStatusCode.fail, resInfo: nil)
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
            isLoaded = true
            
            status.sendStatus(session: sessionID, adsType: self.adsType, status: UAdStatusCode.load, resInfo: interstitial?.responseInfo)
        })
    }
    
    public func show() {
        if interstitial != nil {
            interstitial!.present(fromRootViewController: rootViewController)
        } else {
            delegate?.onFullScreenFailed(msg: "Interstitial Ad is not ready")
        }
    }
}

extension UAdInterstitial: GADFullScreenContentDelegate {
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        LogUtil.shared.log(.debug, msg: "interstitialError")
        delegate?.onFullScreenFailed(msg: error.localizedDescription)
        status.sendStatus(session: sessionID, adsType: self.adsType, status: UAdStatusCode.fail, resInfo: nil)
        print("UAdInterstitial ad")
    }
    public func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        LogUtil.shared.log(.debug, msg: "adDidRecordImpression")
        delegate?.onFullScreenShow()
        status.sendStatus(session: sessionID, adsType: self.adsType, status: UAdStatusCode.show, resInfo: interstitial?.responseInfo)
    }

    public func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        LogUtil.shared.log(.debug, msg: "adDidRecordClick")
        delegate?.onFullScreenClicked()
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        LogUtil.shared.log(.debug, msg: "adDidDismissFullScreenContent")
        delegate?.onFullScreenDismiss()
        status.sendStatus(session: sessionID, adsType: self.adsType, status: UAdStatusCode.close, resInfo: interstitial?.responseInfo)
    }
}
