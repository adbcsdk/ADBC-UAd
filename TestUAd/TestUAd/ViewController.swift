//
//  ViewController.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import UIKit
import SnapKit
import UAdFramework

class ViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var bannerWrapperView: UIView!
    
    var interstitial: UAdInterstitial?
    var reward: UAdRewardedAd?
    
    var nativeAdView: UAdNativeAdView!
    var uAdAdLoader: UAdAdLoader?
    
    var bannerView: UAdBannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(_ tap: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func didTapRegistBtn(_ sender: Any) {
        let userID = idTextField.text!
        UAdMobileAds.shared().initialize(appID: "chEhhIVGS3", userID: userID, isDebug: false, completion: { result, msg in
            print("init result = \(result), msg = \(msg)")
        })
    }
    
    @IBAction func showBanner(_ sender: Any) {
        
        let uAdBanner = UAdBanner(zoneId: "KObo20WlrNKpAoM2fU0mtfIUTS05", rootViewController: self, delegate: self)
        uAdBanner.setSize(size: .BANNER320X50)
        bannerView = uAdBanner.getView()
        bannerView!.load()
    }
    
    @IBAction func loadInterstitial(_ sender: Any) {
        interstitial = UAdInterstitial(zoneId: "A4Uuv5FsmYOIdzAbtq1CK9XDamJO", rootViewController: self, delegate: self)
        interstitial?.load()
    }
    @IBAction func showInterstitial(_ sender: Any) {
        interstitial?.show()
    }
    
    @IBAction func loadNative(_ sender: Any) {
        uAdAdLoader = UAdAdLoader(zoneId: "6ICJ8tuW3wsNQs9DRfBOVNKqKRWy", rootViewController: self, delegate: self)
        uAdAdLoader!.load()
    }
    @IBAction func showNative(_ sender: Any) {
        bannerWrapperView.addSubview(nativeAdView)
        
        nativeAdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
    }
    
    @IBAction func loadReward(_ sender: Any) {
        reward = UAdRewardedAd(zoneId: "NCSlLD5Jg74w0hdgCYrleWid4NLQ", rootViewController: self, delegate: self)
        reward?.load()
    }
    @IBAction func showReward(_ sender: Any) {
        reward?.show()
    }
    
    func addBannerViewToView(_ bannerView: UAdBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: view.safeAreaLayoutGuide,
                              attribute: .bottom,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
    }
}

extension ViewController: UAdBannerViewDelegate {
    func onBannerLoaded() {
        addBannerViewToView(bannerView!)
    }
    
    func onBannerClicked() {
    }
    
    func onBannerFailed(msg: String) {
    }
}

extension ViewController: UAdFullScreenDelegate {
    func onFullScreenLoaded() {
    }
    
    func onFullScreenClicked() {
    }
    
    func onFullScreenShow() {
    }
    
    func onFullScreenDismiss() {
    }
    
    func onFullScreenFailed(msg: String) {
    }
}

extension ViewController: UAdNativeAdLoaderDelegate {
    func onNativeLoaderLoaded(nativeAd: UAdFramework.UAdNativeAd) {
        
        print("onNativeLoaderLoaded")
        
        let nibView = Bundle.main.loadNibNamed("UAdMediumTemplate", owner: nil, options: nil)?.first
        guard let nativeAdView = nibView as? UAdNativeAdView else {
            return
        }
        
        nativeAd.setDelegate(delegate: self)
        self.nativeAdView = nativeAdView
        
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline()
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction(), for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction() == nil

//        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon()
//        nativeAdView.iconView?.isHidden = nativeAd.icon == nil
        
        if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent().getMediaContent().aspectRatio > 0 {
            let heightConstraint = NSLayoutConstraint(
                item: mediaView,
                attribute: .height,
                relatedBy: .equal,
                toItem: mediaView,
                attribute: .width,
                multiplier: CGFloat(1 / nativeAd.mediaContent().getMediaContent().aspectRatio),
                constant: 0)

            heightConstraint.isActive = true
        }
        
        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store()
        nativeAdView.storeView?.isHidden = nativeAd.store() == nil
        
        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser()
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser() == nil
        
        nativeAdView.nativeAd = nativeAd.getNativeAd()
    }
    
    func onNativeLoaderFailed(msg: String) {
    }
}


extension ViewController: UAdNativeAdDelegate {
    func onNativeAdLoaded() {
    }
    func onNativeAdClicked() {
    }
    func onNativeAdShow() {
    }
    func onNativeAdDismiss() {
    }
    func onNativeAdFailed(msg: String) {
    }
}

