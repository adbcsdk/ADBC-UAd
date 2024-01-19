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
    
    public init(adUnitID: String, rootViewController: UIViewController, delegate: UAdNativeAdLoaderDelegate) {
        self.adUnitID = adUnitID
        self.rootViewController = rootViewController
        self.delegate = delegate
        super.init()
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
