//
//  File.swift
//  
//
//  Created by 신아람 on 1/15/24.
//

import UIKit
import GoogleMobileAds

public protocol UAdFullScreenContentDelegate : AnyObject {
    func ad(didFailToPresentFullScreenContentWithError error: Error)

    func adWillPresentFullScreenContent()

    func adDidDismissFullScreenContent()
}

@objcMembers
public class UAdInterstitial: NSObject {
    
    private let adsType = "interstitial"
    private let status = StatusSendHelper()
    
    private var adUnitID: String = "ca-app-pub-3940256099942544/4411468910"
    private var rootViewController: UIViewController
    private var delegate: UAdFullScreenContentDelegate
    
    private var interstitial: GADInterstitialAd?
    
    public init(adUnitID: String, rootViewController: UIViewController, delegate: UAdFullScreenContentDelegate) {
        
        self.adUnitID = adUnitID
        self.rootViewController = rootViewController
        self.delegate = delegate
    }
    
    public func load() {
        
        status.sendStatus(adsType: adsType, status: UAdStatusCode.req, resInfo: nil)
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: request, completionHandler: { [self] ad, error in
            
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                status.sendStatus(adsType: self.adsType, status: UAdStatusCode.fail, resInfo: nil)
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
            
            status.sendStatus(adsType: self.adsType, status: UAdStatusCode.load, resInfo: interstitial?.responseInfo)
        })
    }
    
    public func show() {
        if interstitial != nil {
            interstitial!.present(fromRootViewController: rootViewController)
        } else {
            print("Ad wasn't ready")
        }
    }
}

extension UAdInterstitial: GADFullScreenContentDelegate {
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        delegate.ad(didFailToPresentFullScreenContentWithError: error)
        
        status.sendStatus(adsType: self.adsType, status: UAdStatusCode.fail, resInfo: nil)
        print("UAdInterstitial ad")
    }

    /// Tells the delegate that the ad will present full screen content.
    public func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        delegate.adWillPresentFullScreenContent()
        
        status.sendStatus(adsType: self.adsType, status: UAdStatusCode.show, resInfo: interstitial?.responseInfo)
        print("UAdInterstitial adWillPresentFullScreenContent")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        delegate.adWillPresentFullScreenContent()
        
        status.sendStatus(adsType: self.adsType, status: UAdStatusCode.close, resInfo: interstitial?.responseInfo)
        print("UAdInterstitial adDidDismissFullScreenContent")
    }
}
