//
//  AS.swift
//  TestGreenP
//
//  Created by 신아람 on 1/22/24.
//

import UIKit
import SnapKit
import GoogleMobileAds

public protocol ASDelegate : AnyObject {
    func bannerViewDidReceiveAd(_ bannerView: AS)

    func bannerView(_ bannerView: AS, didFailToReceiveAdWithError error: Error)

    func bannerViewDidRecordImpression(_ bannerView: AS)

    func bannerViewWillPresentScreen(_ bannerView: AS)

    func bannerViewWillDismissScreen(_ bannerView: AS)

    func bannerViewDidDismissScreen(_ bannerView: AS)
}

public class AS: UIView {
    
    private var isLoaded = false
    private var adUnitID: String = "ca-app-pub-3940256099942544/2934735716"
    private var rootViewController: UIViewController?
    private var delegate: ASDelegate?
    
    private var bannerView: GADBannerView?
    
    init(adUnitID: String, rootViewController: UIViewController, delegate: ASDelegate?) {
        
        self.adUnitID = adUnitID
        self.rootViewController = rootViewController
        self.delegate = delegate
        
        super.init(frame: .zero)
        
        backgroundColor = .yellow
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
        frame = CGRect(x: 0, y: 0, width: size.size.width, height: size.size.height)
        bannerView?.adSize = size
    }
    
    public func getView() -> GADBannerView? {
        return bannerView
    }
    
    private func initBannerView() {
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView?.adUnitID = adUnitID
        bannerView?.rootViewController = rootViewController
        bannerView?.delegate = self
        addSubview(bannerView!)
        
        bannerView?.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            
        }
    }
}

extension AS: GADBannerViewDelegate {
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
