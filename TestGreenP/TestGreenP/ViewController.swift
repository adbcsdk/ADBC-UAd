//
//  ViewController.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import UIKit
import SnapKit
import UAdFramework
import GoogleMobileAds

class ViewController: UIViewController, UAdBannerViewDelegate, UAdFullScreenContentDelegate {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    var interstitial: UAdInterstitial?
    var reward: UAdRewardedAd?
    
    var nativeAdView: UAdNativeAdView!
    var uAdAdLoader: UAdAdLoader?
    
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
        UAdMobileAds.shared().initialize(appID: "chEhhIVGS3", userID: userID, isDebug: false)
    }
    
    @IBAction func showBanner(_ sender: Any) {
        
        let uAdBanner = UAdBanner(zoneId: "KObo20WlrNKpAoM2fU0mtfIUTS05", rootViewController: self, delegate: self)
        uAdBanner.setSize(size: .BANNER300X250)
        if let bannerView = uAdBanner.getView() {
            addBannerViewToView(bannerView)
            bannerView.load()
        }
        
//        uAdAdLoader = UAdAdLoader(zoneId: "6ICJ8tuW3wsNQs9DRfBOVNKqKRWy", rootViewController: self, delegate: self)
//        uAdAdLoader!.load()
        
    }
    @IBAction func loadInterstitial(_ sender: Any) {
        interstitial = UAdInterstitial(zoneId: "A4Uuv5FsmYOIdzAbtq1CK9XDamJO", rootViewController: self, delegate: self)
        interstitial?.load()
    }
    @IBAction func showInterstitial(_ sender: Any) {
        interstitial?.show()
    }
    @IBAction func loadReward(_ sender: Any) {
        reward = UAdRewardedAd(zoneId: "NCSlLD5Jg74w0hdgCYrleWid4NLQ", rootViewController: self, delegate: self)
        reward?.load()
    }
    @IBAction func showReward(_ sender: Any) {
        reward?.show()
    }
    
    func setAdView(_ view: UAdNativeAdView) {
      // Remove the previous ad view.
        nativeAdView = view
        
        self.view.addSubview(nativeAdView)
//        nativeAdView.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for positioning the native ad view to stretch the entire width and height
        // of the nativeAdPlaceholder.
//        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addConstraints(
//          [NSLayoutConstraint(item: view,
//                              attribute: .bottom,
//                              relatedBy: .equal,
//                              toItem: self.view.safeAreaLayoutGuide,
//                              attribute: .bottom,
//                              multiplier: 1,
//                              constant: 0),
//           NSLayoutConstraint(item: view,
//                              attribute: .centerX,
//                              relatedBy: .equal,
//                              toItem: self.view,
//                              attribute: .centerX,
//                              multiplier: 1,
//                              constant: 0)
//          ])
    }
    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
      guard let rating = starRating?.doubleValue else {
        return nil
      }
      if rating >= 5 {
        return UIImage(named: "stars_5")
      } else if rating >= 4.5 {
        return UIImage(named: "stars_4_5")
      } else if rating >= 4 {
        return UIImage(named: "stars_4")
      } else if rating >= 3.5 {
        return UIImage(named: "stars_3_5")
      } else {
        return nil
      }
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
    
    func bannerViewDidReceiveAd(_ bannerView: UAdBannerView) {
      print("bannerViewDidReceiveAd")
    }
    
    func bannerViewDidFailToReceiveAdWithError(error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: UAdBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: UAdBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: UAdBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: UAdBannerView) {
      print("bannerViewDidDismissScreen")
    }
    
    func ad(didFailToPresentFullScreenContentWithError error: Error) {
        print("fullscreen ad")
    }
    
    func adWillPresentFullScreenContent() {
        print("fullscreen adWillPresentFullScreenContent")
    }
    
    func adDidDismissFullScreenContent() {
        print("fullscreen adDidDismissFullScreenContent")
    }
}

extension ViewController: UAdNativeAdLoaderDelegate {
    
    func adLoader(_ adLoader: UAdAdLoader, didReceive nativeAd: UAdNativeAd) {
        
        // Create and place ad in view hierarchy.
        let nibView = Bundle.main.loadNibNamed("UAdNativeAdView", owner: nil, options: nil)?.first
        guard let nativeAdView = nibView as? UAdNativeAdView else {
            return
        }
        
        nativeAd.setDelegate(delegate: self)
        
        setAdView(nativeAdView)
        
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline()
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction(), for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction() == nil

        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon()
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil
        
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
    
    func adLoaderDidFinishLoading(_ adLoader: UAdAdLoader) {
        print("adLoader adLoaderDidFinishLoading")
    }
    
    func adLoader(_ adLoader: UAdAdLoader, didFailToReceiveAdWithError error: Error) {
        print("adLoader error")
    }
    
    
}

extension ViewController: UAdNativeAdDelegate {
    func nativeAdDidRecordClick() {
        print("nativeAdDidRecordClick")
    }
    
    func nativeAdDidRecordImpression() {
        print("nativeAdDidRecordImpression")
    }
    
    func nativeAdWillPresentScreen() {
        print("nativeAdWillPresentScreen")
    }
    
    func nativeAdWillDismissScreen() {
        print("nativeAdWillDismissScreen")
    }
    
    func nativeAdDidDismissScreen() {
        print("nativeAdDidDismissScreen")
    }
    
    func nativeAdWillLeaveApplication() {
        print("nativeAdWillLeaveApplication")
    }
    
    
}
