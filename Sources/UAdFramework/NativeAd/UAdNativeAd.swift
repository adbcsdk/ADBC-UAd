//
//  UAdNativeAd.swift
//  
//  Created by 신아람 on 1/16/24.
//

import UIKit
import GoogleMobileAds

public protocol UAdNativeAdDelegate : AnyObject {
    func onNativeAdClicked()
    func onNativeAdShow()
    func onNativeAdDismiss()
}

@objcMembers
public class UAdNativeAd: NSObject {
    
    private let adsType = "native"
    private let sessionID: String
    private let status = StatusSendHelper()
    
    private let nativeAd: GADNativeAd
    private var delegate: UAdNativeAdDelegate?
    
    init(nativeAd: GADNativeAd, sessionID: String) {
        self.nativeAd = nativeAd
        self.sessionID = sessionID
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
        delegate?.onNativeAdClicked()
    }

    public func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        status.sendStatus(session: sessionID, adsType: adsType, status: .show, resInfo: nativeAd.responseInfo)
        delegate?.onNativeAdShow()
    }

    public func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        status.sendStatus(session: sessionID, adsType: adsType, status: .close, resInfo: nativeAd.responseInfo)
        delegate?.onNativeAdDismiss()
    }
}
