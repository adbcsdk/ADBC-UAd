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
    
    var nativeAdView: GADTSmallTemplateView!
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
        UAdMobileAds.shared().initialize(appID: "5FZ7Gb2FxH", userID: userID, isTest: false)
    }
    
    @IBAction func showBanner(_ sender: Any) {
        
//        let uAdBanner = UAdBanner(adUnitID: "ca-app-pub-3940256099942544/2934735716", rootViewController: self, delegate: self)
//        if let bannerView = uAdBanner.getView() {
//            addBannerViewToView(bannerView)
//            bannerView.load()
//        }
        
        uAdAdLoader = UAdAdLoader(adUnitID: "ca-app-pub-3940256099942544/3986624511", rootViewController: self, delegate: self)
        uAdAdLoader!.load()
        
    }
    @IBAction func loadInterstitial(_ sender: Any) {
        interstitial = UAdInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910", rootViewController: self, delegate: self)
        interstitial?.load()
    }
    @IBAction func showInterstitial(_ sender: Any) {
        interstitial?.show()
    }
    @IBAction func loadReward(_ sender: Any) {
        reward = UAdRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313", rootViewController: self, delegate: self)
        reward?.load()
    }
    @IBAction func showReward(_ sender: Any) {
        reward?.show()
    }
    
    func setAdView(_ view: GADTSmallTemplateView) {
      // Remove the previous ad view.
        nativeAdView = view
        
        self.view.addSubview(nativeAdView)
//        nativeAdView.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for positioning the native ad view to stretch the entire width and height
        // of the nativeAdPlaceholder.
        
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

    func bannerView(_ bannerView: UAdBannerView, didFailToReceiveAdWithError error: Error) {
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
        let nibView = Bundle.main.loadNibNamed("GADTSmallTemplateView", owner: nil, options: nil)?.first
        guard let nativeAdView = nibView as? GADTSmallTemplateView else {
            return
        }
        
        nativeAd.setDelegate(delegate: self)
        
        setAdView(nativeAdView)
        
        
        // Set ourselves as the native ad delegate to be notified of native ad events.
//        nativeAd.delegate = self

        // Populate the native ad view with the native ad assets.
        // The headline and mediaContent are guaranteed to be present in every native ad.
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline()
//        nativeAdView.setMediaContent(mediaContent: nativeAd.mediaContent())
        
        // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
        // ratio of the media it displays.
//        if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent().getMediaContent().aspectRatio > 0 {
//            let heightConstraint = NSLayoutConstraint(
//                item: mediaView,
//                attribute: .height,
//                relatedBy: .equal,
//                toItem: mediaView,
//                attribute: .width,
//                multiplier: CGFloat(1 / nativeAd.mediaContent().getMediaContent().aspectRatio),
//                constant: 0)
//            
//            heightConstraint.isActive = true
//
//        }

        // These assets are not guaranteed to be present. Check that they are before
        // showing or hiding them.
//        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body()
//        nativeAdView.bodyView?.isHidden = nativeAd.body() == nil

        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction(), for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction() == nil

        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon()
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil

//        (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating())
//        nativeAdView.starRatingView?.isHidden = nativeAd.starRating() == nil

        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store()
        nativeAdView.storeView?.isHidden = nativeAd.store() == nil

//        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price()
//        nativeAdView.priceView?.isHidden = nativeAd.price() == nil

        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser()
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser() == nil

        // In order for the SDK to process touch events properly, user interaction should be disabled.
        nativeAdView.callToActionView?.isUserInteractionEnabled = false

        let myBlueColor = "#5C84F0"
        let styles: [GADTNativeTemplateStyleKey: NSObject] = [
            .callToActionFont: UIFont.systemFont(ofSize: 15.0),
            .callToActionFontColor: UIColor.white,
            .callToActionBackgroundColor: GADTTemplateView.color(fromHexString: myBlueColor),
            .secondaryFont: UIFont.systemFont(ofSize: 15.0),
            .secondaryFontColor: UIColor.gray,
            .secondaryBackgroundColor: UIColor.white,
            .primaryFont: UIFont.systemFont(ofSize: 15.0),
            .primaryFontColor: UIColor.black,
            .primaryBackgroundColor: UIColor.white,
            .tertiaryFont: UIFont.systemFont(ofSize: 15.0),
            .tertiaryFontColor: UIColor.gray,
            .tertiaryBackgroundColor: UIColor.white,
            .mainBackgroundColor: UIColor.white,
            .cornerRadius: NSNumber(value: Float(7.0))
        ]

        nativeAdView.styles = styles
        
        
        // Associate the native ad view with the native ad object. This is
        // required to make the ad clickable.
        // Note: this should always be done after populating the ad views.
//        nativeAdView.setNativeAd(nativeAd: nativeAd)
        nativeAdView.nativeAd = nativeAd.getNativeAd()
        
        nativeAdView.addHorizontalConstraintsToSuperviewWidth()
        nativeAdView.addVerticalCenterConstraintToSuperview()
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
