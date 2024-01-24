//
//  File.swift
//  
//
//  Created by 신아람 on 1/15/24.
//

import UIKit
import GoogleMobileAds

public protocol UAdNativeAdLoaderDelegate : AnyObject {
    func adLoader(_ adLoader: UAdAdLoader, didReceive nativeAd: UAdNativeAd)

    func adLoaderDidFinishLoading(_ adLoader: UAdAdLoader)

    func adLoader(_ adLoader: UAdAdLoader, didFailToReceiveAdWithError error: Error)
}

@objcMembers
public class UAdAdLoader: NSObject {
    private var adUnitID: String = "ca-app-pub-3940256099942544/3986624511"
    private var rootViewController: UIViewController
    private var delegate: UAdNativeAdLoaderDelegate
    
    private var adLoader: GADAdLoader!
    private var nativeAd: UAdNativeAd!
    
    public init(zoneId: String, rootViewController: UIViewController, delegate: UAdNativeAdLoaderDelegate) {
        
        self.rootViewController = rootViewController
        self.delegate = delegate
        super.init()
        
        if let ad = UserInfo.shared.adCodes.first(where: { $0.zone == zoneId }) {
            self.adUnitID = ad.code
        } else {
            self.adUnitID = ""
//            let error = NSError(domain: "UAdFramework", code: 999, userInfo: [NSLocalizedDescriptionKey: "Zone Id not found"])
//            delegate?.bannerViewDidFailToReceiveAdWithError(error: error)
        }
    }
    
    public func load() {
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
        self.nativeAd = UAdNativeAd(nativeAd: nativeAd)
        delegate.adLoader(self, didReceive: self.nativeAd)
    }
    
    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        delegate.adLoader(self, didFailToReceiveAdWithError: error)
    }
}
