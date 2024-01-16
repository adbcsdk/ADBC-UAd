//
//  File.swift
//  
//
//  Created by 신아람 on 1/16/24.
//

import UIKit
import GoogleMobileAds

public class UAdBanner {
    
    private var bannerView: UAdBannerView?
    
    public init(adUnitID: String, rootViewController: UIViewController, delegate: UAdBannerViewDelegate) {
        bannerView = UAdBannerView(adUnitID: adUnitID, rootViewController: rootViewController, delegate: delegate)
    }
    
    public func load() {
        bannerView?.load()
    }
    
    public func setSize(size: UAdBannerSize) {
        bannerView?.setSize(size: sizeConverter(size: size))
    }
    
    public func setSize(width: CGFloat, height: CGFloat) {
        bannerView?.setSize(size: GADAdSizeFromCGSize(CGSize(width: width, height: height)))
    }
    
    public func getView() -> UAdBannerView? {
        return bannerView
    }
    
    private func sizeConverter(size: UAdBannerSize) -> GADAdSize {
        
        switch size {
        case .BANNER320X50:
            return GADAdSizeBanner
        case .BANNER320X100:
            return GADAdSizeLargeBanner
        case .BANNER300X250:
            return GADAdSizeMediumRectangle
        case .BANNER468X60:
            return GADAdSizeFullBanner
        case .BANNER728X90:
            return GADAdSizeLeaderboard
        }
    }
}
