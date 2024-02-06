//
//  UAdRewardedAd.swift
//
//  Created by 신아람 on 1/15/24.
//

import UIKit
import GoogleMobileAds

@objcMembers
public class UAdRewardedAd: NSObject {
    
    private let adsType = "reward"
    private let sessionID: String
    private let status = StatusSendHelper()
    
    private var isLoaded = false
    private var adUnitID: String = "ca-app-pub-3940256099942544/1712485313"
    private var rootViewController: UIViewController
    private var delegate: UAdFullScreenDelegate?
    
    private var rewardedAd: GADRewardedAd?
    
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
        status.sendStatus(session: sessionID, adsType: self.adsType, status: UAdStatusCode.req, resInfo: nil)
        
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: adUnitID, request: request, completionHandler: { [self] ad, error in
            
            if let error = error {
                LogUtil.shared.log(.debug, msg: "Failed to load interstitial ad with error: \(error.localizedDescription)")
                status.sendStatus(session: sessionID, adsType: self.adsType, status: UAdStatusCode.fail, resInfo: nil)
                return
            }
            rewardedAd = ad
            rewardedAd?.fullScreenContentDelegate = self
            isLoaded = true
            
            delegate?.onFullScreenLoaded()
            status.sendStatus(session: sessionID, adsType: self.adsType, status: UAdStatusCode.load, resInfo: nil)
        })
    }
    
    public func show() {
        if let ad = rewardedAd {
            ad.present(fromRootViewController: rootViewController) {
                let reward = ad.adReward
                LogUtil.shared.log(.debug, msg: "Reward received with currency \(reward.type), amount \(reward.amount)")
                    // TODO: Reward the user.
                
            }
        } else {
            delegate?.onFullScreenFailed(msg: "Reward Ad is not ready")
        }
    }
}

extension UAdRewardedAd: GADFullScreenContentDelegate {
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        LogUtil.shared.log(.debug, msg: "rewardAdError")
        delegate?.onFullScreenFailed(msg: error.localizedDescription)
        status.sendStatus(session: sessionID, adsType: self.adsType, status: UAdStatusCode.fail, resInfo: nil)
    }

    public func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        LogUtil.shared.log(.debug, msg: "adDidRecordImpression")
        delegate?.onFullScreenShow()
        status.sendStatus(session: sessionID, adsType: self.adsType, status: UAdStatusCode.show, resInfo: nil)
    }
    
    public func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        LogUtil.shared.log(.debug, msg: "adDidRecordClick")
        delegate?.onFullScreenClicked()
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        LogUtil.shared.log(.debug, msg: "adDidDismissFullScreenContent")
        delegate?.onFullScreenDismiss()
        status.sendStatus(session: sessionID, adsType: self.adsType, status: UAdStatusCode.close, resInfo: nil)
    }
}
