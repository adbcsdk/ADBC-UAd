//
//  File.swift
//  
//
//  Created by 신아람 on 1/15/24.
//

import UIKit
import GoogleMobileAds

@objcMembers
public class UAdRewardedAd: NSObject {
    
    private let adsType = "reward"
    private let status = StatusSendHelper()
    
    private var isLoaded = false
    private var adUnitID: String = "ca-app-pub-3940256099942544/1712485313"
    private var rootViewController: UIViewController
    private var delegate: UAdFullScreenContentDelegate?
    
    private var rewardedAd: GADRewardedAd?
    
    public init(zoneId: String, rootViewController: UIViewController, delegate: UAdFullScreenContentDelegate?) {
        
        self.rootViewController = rootViewController
        self.delegate = delegate
        
        if let ad = UserInfo.shared.adCodes.first(where: { $0.zone == zoneId }) {
            self.adUnitID = ad.code
        } else {
            self.adUnitID = ""
//            let error = NSError(domain: "UAdFramework", code: 999, userInfo: [NSLocalizedDescriptionKey: "Zone Id not found"])
//            delegate?.bannerViewDidFailToReceiveAdWithError(error: error)
        }
    }
    
    public func load() {
        
        if isLoaded { return }
        
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: adUnitID, request: request, completionHandler: { [self] ad, error in
            
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            rewardedAd = ad
            rewardedAd?.fullScreenContentDelegate = self
            isLoaded = true
        })
    }
    
    public func show() {
        if let ad = rewardedAd {
            ad.present(fromRootViewController: rootViewController) {
                let reward = ad.adReward
                    print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                    // TODO: Reward the user.
            }
        } else {
            print("Ad wasn't ready")
        }
    }
}

extension UAdRewardedAd: GADFullScreenContentDelegate {
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        delegate?.ad(didFailToPresentFullScreenContentWithError: error)
    }

    /// Tells the delegate that the ad will present full screen content.
    public func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        delegate?.adWillPresentFullScreenContent()
    }

    /// Tells the delegate that the ad dismissed full screen content.
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        delegate?.adWillPresentFullScreenContent()
    }
}
