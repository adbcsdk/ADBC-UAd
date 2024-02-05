//
//  UAdAdLoader.swift
//  
//  Created by 신아람 on 1/15/24.
//

import UIKit
import GoogleMobileAds

public protocol UAdNativeAdLoaderDelegate : AnyObject {
    func onNativeLoaderLoaded(nativeAd: UAdNativeAd)
    func onNativeLoaderFailed(msg: String)
}

@objcMembers
public class UAdAdLoader: NSObject {
    
    private let adsType = "native"
    private let sessionID: String
    private let status = StatusSendHelper()
    
    private var adUnitID: String = "ca-app-pub-3940256099942544/3986624511"
    private var rootViewController: UIViewController
    private var delegate: UAdNativeAdLoaderDelegate
    
    private var adLoader: GADAdLoader!
    private var nativeAd: UAdNativeAd?
    
    public init(zoneId: String, rootViewController: UIViewController, delegate: UAdNativeAdLoaderDelegate) {
        
        self.rootViewController = rootViewController
        self.delegate = delegate
        self.sessionID = UUID().uuidString
        super.init()
        
        if let ad = UserInfo.shared.adCodes.first(where: { $0.zone == zoneId }) {
            self.adUnitID = ad.code
        } else {
            self.adUnitID = ""
        }
    }
    
    public func load() {
        
        if(adUnitID.isEmpty) {
            delegate.onNativeLoaderFailed(msg: "Zone Id not found")
            return
        }
        
        status.sendStatus(session: sessionID, adsType: adsType, status: .req, resInfo: nativeAd?.getNativeAd().responseInfo)
        
        let multipleAdOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdOptions.numberOfAds = 5;
        adLoader = GADAdLoader(adUnitID: adUnitID,
            rootViewController: rootViewController,
            adTypes: [ .native ],
            options: [ multipleAdOptions ])

        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
}

extension UAdAdLoader: GADNativeAdLoaderDelegate {
    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        self.nativeAd = UAdNativeAd(nativeAd: nativeAd, sessionID: sessionID)
    }
    
    public func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        LogUtil.shared.log(.debug, msg: "adLoaderDidFinishLoading")
        status.sendStatus(session: sessionID, adsType: adsType, status: .load, resInfo: nativeAd?.getNativeAd().responseInfo)
        if(nativeAd != nil) {
            delegate.onNativeLoaderLoaded(nativeAd: nativeAd!)
        } else {
            delegate.onNativeLoaderFailed(msg: "native Ad Error")
        }
    }
    
    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        LogUtil.shared.log(.debug, msg: "nativeAdError")
        status.sendStatus(session: sessionID, adsType: adsType, status: .fail, resInfo: nativeAd?.getNativeAd().responseInfo)
        delegate.onNativeLoaderFailed(msg: error.localizedDescription)
    }
}
