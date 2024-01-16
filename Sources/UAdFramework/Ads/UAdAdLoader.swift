//
//  File.swift
//  
//
//  Created by 신아람 on 1/15/24.
//

import UIKit
import GoogleMobileAds

public protocol UAdNativeAdLoaderDelegate : AnyObject {
    func adLoader(_ adLoader: UAdAdLoader, didReceive nativeAd: GADNativeAd)

    func adLoaderDidFinishLoading(_ adLoader: UAdAdLoader)

    func adLoader(_ adLoader: UAdAdLoader, didFailToReceiveAdWithError error: Error)
}

@objcMembers
public class UAdAdLoader: NSObject {
    
    private var adUnitID: String = "ca-app-pub-3940256099942544/4411468910"
    private var rootViewController: UIViewController
    private var delegate: UAdNativeAdLoaderDelegate
    
    private var adLoader: GADAdLoader!
    
    public init(adUnitID: String, rootViewController: UIViewController, delegate: UAdNativeAdLoaderDelegate) {
        self.adUnitID = adUnitID
        self.rootViewController = rootViewController
        self.delegate = delegate
        
        super.init()
        
        let multipleAdOptions = GADMultipleAdsAdLoaderOptions()
        adLoader = GADAdLoader(adUnitID: self.adUnitID, rootViewController: self.rootViewController, adTypes: [ .native ], options: [ multipleAdOptions ])
        adLoader.delegate = self
    }
}

extension UAdAdLoader: GADNativeAdLoaderDelegate {
    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        // A native ad has loaded, and can be displayed.
        delegate.adLoader(self, didReceive: nativeAd)
    }

    public func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        // The adLoader has finished loading ads, and a new request can be sent.
        delegate.adLoaderDidFinishLoading(self)
    }
    
    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        delegate.adLoader(self, didFailToReceiveAdWithError: error)
    }

}
