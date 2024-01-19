//
//  File.swift
//  
//
//  Created by 신아람 on 1/12/24.
//

import UIKit
import SnapKit
import GoogleMobileAds

public enum UAdBannerSize {
    case BANNER320X50
    case BANNER320X100
    case BANNER300X250
    case BANNER468X60
    case BANNER728X90
}

public protocol UAdBannerViewDelegate : AnyObject {
    func bannerViewDidReceiveAd(_ bannerView: UAdBannerView)

    func bannerView(_ bannerView: UAdBannerView, didFailToReceiveAdWithError error: Error)

    func bannerViewDidRecordImpression(_ bannerView: UAdBannerView)

    func bannerViewWillPresentScreen(_ bannerView: UAdBannerView)

    func bannerViewWillDismissScreen(_ bannerView: UAdBannerView)

    func bannerViewDidDismissScreen(_ bannerView: UAdBannerView)
}

public class UAdBannerView: UIView {
    
    private let adsType = "banner"
    private let status = StatusSendHelper()
    
    private var isLoaded = false
    private var adUnitID: String = "ca-app-pub-3940256099942544/2934735716"
    private var rootViewController: UIViewController?
    private var delegate: UAdBannerViewDelegate?
    
    private var bannerView: GADBannerView?
    
    init(adUnitID: String, rootViewController: UIViewController, delegate: UAdBannerViewDelegate?) {
        
        self.adUnitID = adUnitID
        self.rootViewController = rootViewController
        self.delegate = delegate
        
        super.init(frame: .zero)
        
        initBannerView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Never Will Happen")
    }
    
    public func load() {
        
        if isLoaded { return }
        
        bannerView?.load(GADRequest())
    }
    
    public func setSize(size: GADAdSize) {
        bannerView?.adSize = size
    }
    
    private func initBannerView() {
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView?.adUnitID = adUnitID
        bannerView?.rootViewController = rootViewController
        bannerView?.delegate = self
        addSubview(bannerView!)
        
        bannerView?.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview()
            
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            
        }
    }
}

extension UAdBannerView: GADBannerViewDelegate {
    public func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        isLoaded = true
        delegate?.bannerViewDidReceiveAd(self)
        
        print("UAdBannerView bannerViewDidReceiveAd")
    }

    public func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        delegate?.bannerView(self, didFailToReceiveAdWithError: error)
        
        print("UAdBannerView bannerView")
    }

    public func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        delegate?.bannerViewDidRecordImpression(self)
        
        print("UAdBannerView bannerViewDidRecordImpression")
    }

    public func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        delegate?.bannerViewWillPresentScreen(self)
        
        print("UAdBannerView bannerViewWillPresentScreen")
    }

    public func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        delegate?.bannerViewWillDismissScreen(self)
        
        print("UAdBannerView bannerViewWillDismissScreen")
    }

    public func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        delegate?.bannerViewDidDismissScreen(self)
        
        print("UAdBannerView bannerViewDidDismissScreen")
    }
}
