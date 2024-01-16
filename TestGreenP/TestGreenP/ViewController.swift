//
//  ViewController.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import UIKit
import SnapKit
import UAdFramework

class ViewController: UIViewController, UAdBannerViewDelegate, UAdFullScreenContentDelegate {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    var interstitial: UAdInterstitial?
    var reward: UAdRewardedAd?
    
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
        
        let uAdBanner = UAdBanner(adUnitID: "ca-app-pub-3940256099942544/2934735716", rootViewController: self, delegate: self)
        if let bannerView = uAdBanner.getView() {
            addBannerViewToView(bannerView)
            bannerView.load()
        }
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
