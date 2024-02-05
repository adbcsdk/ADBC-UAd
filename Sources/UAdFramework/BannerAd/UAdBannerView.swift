//
//  UAdBannerView.swift
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
    func onBannerLoaded()
    func onBannerClicked()
    func onBannerFailed(msg: String)
}

public class UAdBannerView: UIView {
    
    private let adsType = "banner"
    private let sessionID: String
    private let status = StatusSendHelper()
    
    private var isLoaded = false
    private var adUnitID: String = "ca-app-pub-3940256099942544/2934735716"
    private var rootViewController: UIViewController?
    private var delegate: UAdBannerViewDelegate?
    
    private var bannerView: GADBannerView?
    
    init(adUnitID: String, rootViewController: UIViewController?, delegate: UAdBannerViewDelegate?) {
        
        self.adUnitID = adUnitID
        self.rootViewController = rootViewController
        self.delegate = delegate
        self.sessionID = UUID().uuidString
        
        super.init(frame: .zero)
        
        initBannerView()
    }
    
    override init(frame: CGRect) {
        self.sessionID = UUID().uuidString
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        self.sessionID = UUID().uuidString
        super.init(coder: aDecoder)
        fatalError("Never Will Happen")
    }
    
    public func load() {
        if isLoaded { return }
        status.sendStatus(session: sessionID, adsType: adsType, status: UAdStatusCode.req, resInfo: bannerView?.responseInfo)
        bannerView?.load(GADRequest())
    }
    
    public func setSize(size: GADAdSize) {
        frame = CGRect(x: 0, y: 0, width: size.size.width, height: size.size.height)
        bannerView?.adSize = size
    }
    
    public func setViewController(viewController: UIViewController) {
        bannerView?.rootViewController = viewController
    }
    
    private func initBannerView() {
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView?.adUnitID = adUnitID
        bannerView?.rootViewController = rootViewController
        bannerView?.delegate = self
        addSubview(bannerView!)
        
        bannerView?.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
}

extension UAdBannerView: GADBannerViewDelegate {
    public func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        LogUtil.shared.log(.debug, msg: "bannerViewDidReceiveAd")
        if(!isLoaded) {
            isLoaded = true
            delegate?.onBannerLoaded()
            status.sendStatus(session: sessionID, adsType: adsType, status: UAdStatusCode.load, resInfo: self.bannerView?.responseInfo)
        }
    }
    public func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        LogUtil.shared.log(.debug, msg: "bannerViewError")
        delegate?.onBannerFailed(msg: error.localizedDescription)
       
        
        status.sendStatus(session: sessionID, adsType: adsType, status: UAdStatusCode.fail, resInfo: self.bannerView?.responseInfo)
    }
    public func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
        LogUtil.shared.log(.debug, msg: "bannerViewDidRecordClick")
        delegate?.onBannerClicked()
    }
    
    public func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        LogUtil.shared.log(.debug, msg: "bannerViewDidRecordImpression")
        status.sendStatus(session: sessionID, adsType: adsType, status: UAdStatusCode.show, resInfo: self.bannerView?.responseInfo)
    }
    
    public func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        LogUtil.shared.log(.debug, msg: "bannerViewDidDismissScreen")
        status.sendStatus(session: sessionID, adsType: adsType, status: UAdStatusCode.close, resInfo: self.bannerView?.responseInfo)
    }
}
