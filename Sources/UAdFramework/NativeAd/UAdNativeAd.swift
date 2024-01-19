//
//  File.swift
//  
//
//  Created by 신아람 on 1/16/24.
//

import UIKit
import GoogleMobileAds

public protocol UAdNativeAdDelegate : AnyObject {
    func nativeAdDidRecordClick()

    func nativeAdDidRecordImpression()

    func nativeAdWillPresentScreen()

    func nativeAdWillDismissScreen()

    func nativeAdDidDismissScreen()

    func nativeAdWillLeaveApplication()
}

@objcMembers
public class UAdNativeAd: NSObject {
    
    private let nativeAd: GADNativeAd
    private var delegate: UAdNativeAdDelegate?
    
    init(nativeAd: GADNativeAd) {
        self.nativeAd = nativeAd
        super.init()
        
        self.nativeAd.delegate = self
    }
    
    public func setDelegate(delegate: UAdNativeAdDelegate) {
        self.delegate = delegate
    }
    
    public func headline() -> String? {
        return nativeAd.headline
    }
    
    public func mediaContent() -> UAdMediaContent {
        return UAdMediaContent(mediaContent: nativeAd.mediaContent)
    }
    
    public func body() -> String? {
        return nativeAd.body
    }
    
    public func callToAction() -> String? {
        return nativeAd.callToAction
    }
    
    public func icon() -> UIImage? {
        return nativeAd.icon?.image
    }
    
    public func starRating() -> NSDecimalNumber? {
        return nativeAd.starRating
    }
    
    public func store() -> String? {
        return nativeAd.store
    }
    
    public func price() -> String? {
        return nativeAd.price
    }
    
    public func advertiser() -> String? {
        return nativeAd.advertiser
    }
    
    public func getNativeAd() -> GADNativeAd {
        return nativeAd
    }
}

extension UAdNativeAd: GADNativeAdDelegate {
    public func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        delegate?.nativeAdDidRecordClick()
    }

    public func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        delegate?.nativeAdDidRecordImpression()
    }

    public func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
        delegate?.nativeAdWillPresentScreen()
    }

    public func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
        delegate?.nativeAdWillDismissScreen()
    }

    public func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        delegate?.nativeAdDidDismissScreen()
    }

    public func nativeAdWillLeaveApplication(_ nativeAd: GADNativeAd) {
        delegate?.nativeAdWillLeaveApplication()
    }
}
