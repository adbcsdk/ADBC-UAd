//
//  File.swift
//  
//
//  Created by 신아람 on 1/18/24.
//

import GoogleMobileAds

public class UAdNativeAdView: GADNativeAdView {
    public func setNativeAd(nativeAd: UAdNativeAd) {
        self.nativeAd = nativeAd.getNativeAd()
    }
    
    public func setMediaContent(mediaContent: UAdMediaContent) {
        self.mediaView?.mediaContent = mediaContent.getMediaContent()
    }
}
