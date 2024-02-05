//
//  UAdNativeAdView.swift
//  
//  Created by 신아람 on 1/18/24.
//

import UIKit
import GoogleMobileAds

public enum UAdNativeTemplateStyleKey: String {
    // Call To Action
    case callToActionFont = "call_to_action_font"
    case callToActionFontColor = "call_to_action_font_color"
    case callToActionBackgroundColor = "call_to_action_background_color"

    // Primary Text
    case primaryFont = "primary_font"
    case primaryFontColor = "primary_font_color"
    case primaryBackgroundColor = "primary_background_color"

    // Secondary Text
    case secondaryFont = "secondary_font"
    case secondaryFontColor = "secondary_font_color"
    case secondaryBackgroundColor = "secondary_background_color"

    // Tertiary Text
    case tertiaryFont = "tertiary_font"
    case tertiaryFontColor = "tertiary_font_color"
    case tertiaryBackgroundColor = "tertiary_background_color"

    // Additional Style Options
    case mainBackgroundColor = "main_background_color"
    case cornerRadius = "corner_radius"
}

public class UAdNativeAdView: GADNativeAdView {
    public var styles: [UAdNativeTemplateStyleKey: Any]?
    @IBOutlet weak var adBadge: UILabel!
    weak var rootView: UIView?
    
    public override var nativeAd: GADNativeAd? {
        didSet {
            applyStyles()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func commonInit() {
        guard let rootView = Bundle.main.loadNibNamed(String(describing: type(of: self)),
                                                      owner: self,
                                                      options: nil)?.first as? UIView else {
            return
        }
        self.rootView = rootView
        addSubview(rootView)
        addConstraintsToRootView()
        applyStyles()
    }

    func applyStyles() {
        
        layer.borderColor = UAdNativeAdView.colorFromHexString("E0E0E0")?.cgColor
        layer.borderWidth = 1.0
        mediaView?.sizeToFit()

        if let cornerRadius = styleForKey(UAdNativeTemplateStyleKey.cornerRadius) as? NSNumber {
            let roundedCornerRadius = CGFloat(cornerRadius.floatValue)
            (iconView as? UIImageView)?.layer.cornerRadius = roundedCornerRadius
            (iconView as? UIImageView)?.clipsToBounds = true
            (callToActionView as? UIButton)?.layer.cornerRadius = roundedCornerRadius
            (callToActionView as? UIButton)?.clipsToBounds = true
        }

        // Fonts
        if let primaryFont = styleForKey(UAdNativeTemplateStyleKey.primaryFont) as? UIFont {
            (headlineView as? UILabel)?.font = primaryFont
        }

        if let secondaryFont = styleForKey(UAdNativeTemplateStyleKey.secondaryFont) as? UIFont {
            (bodyView as? UILabel)?.font = secondaryFont
        }

        if let tertiaryFont = styleForKey(UAdNativeTemplateStyleKey.tertiaryFont) as? UIFont {
            (advertiserView as? UILabel)?.font = tertiaryFont
        }

        if let ctaFont = styleForKey(UAdNativeTemplateStyleKey.callToActionFont) as? UIFont {
            (callToActionView as? UIButton)?.titleLabel?.font = ctaFont
        }

        // Font colors
        if let primaryFontColor = styleForKey(UAdNativeTemplateStyleKey.primaryFontColor) as? UIColor {
            (headlineView as? UILabel)?.textColor = primaryFontColor
        }

        if let secondaryFontColor = styleForKey(UAdNativeTemplateStyleKey.secondaryFontColor) as? UIColor {
            (bodyView as? UILabel)?.textColor = secondaryFontColor
        }

        if let tertiaryFontColor = styleForKey(UAdNativeTemplateStyleKey.tertiaryFontColor) as? UIColor {
            (advertiserView as? UILabel)?.textColor = tertiaryFontColor
        }

        if let ctaFontColor = styleForKey(UAdNativeTemplateStyleKey.callToActionFontColor) as? UIColor {
            (callToActionView as? UIButton)?.setTitleColor(ctaFontColor, for: .normal)
        }

        // Background colors
        if let primaryBackgroundColor = styleForKey(UAdNativeTemplateStyleKey.primaryBackgroundColor) as? UIColor {
            (headlineView as? UILabel)?.backgroundColor = primaryBackgroundColor
        }

        if let secondaryBackgroundColor = styleForKey(UAdNativeTemplateStyleKey.secondaryBackgroundColor) as? UIColor {
            (bodyView as? UILabel)?.backgroundColor = secondaryBackgroundColor
        }

        if let tertiaryBackgroundColor = styleForKey(UAdNativeTemplateStyleKey.tertiaryBackgroundColor) as? UIColor {
            (advertiserView as? UILabel)?.backgroundColor = tertiaryBackgroundColor
        }

        if let ctaBackgroundColor = styleForKey(UAdNativeTemplateStyleKey.callToActionBackgroundColor) as? UIColor {
            (callToActionView as? UIButton)?.backgroundColor = ctaBackgroundColor
        }

        if let mainBackgroundColor = styleForKey(UAdNativeTemplateStyleKey.mainBackgroundColor) as? UIColor {
            backgroundColor = mainBackgroundColor
        }

        styleAdBadge()
    }

    func getTemplateTypeName() -> String {
        return "root"
    }
    
    func styleForKey(_ key: UAdNativeTemplateStyleKey) -> Any? {
        return styles?[key]
    }

    func styleAdBadge() {
        guard let adBadge = adBadge else { return }
        adBadge.layer.borderColor = adBadge.textColor.cgColor
        adBadge.layer.borderWidth = 1.0
        adBadge.layer.cornerRadius = 3.0
        adBadge.layer.masksToBounds = true
    }

    func setStyles(_ styles: [UAdNativeTemplateStyleKey: Any]) {
        self.styles = styles
        applyStyles()
    }

    func setNativeAd(nativeAd: UAdNativeAd) {
        
        (headlineView as? UILabel)?.text = nativeAd.headline()
        (iconView as? UIImageView)?.image = nativeAd.icon()
        (callToActionView as? UIButton)?.setTitle(nativeAd.callToAction(), for: .normal)

        if let advertiser = nativeAd.advertiser() {
            (advertiserView as? UILabel)?.text = advertiser
            (advertiserView as? UILabel)?.isHidden = false
            (storeView as? UILabel)?.isHidden = true
        } else if let store = nativeAd.store() {
            (storeView as? UILabel)?.text = store
            (advertiserView as? UILabel)?.isHidden = true
            (storeView as? UILabel)?.isHidden = false
        } else {
            (advertiserView as? UILabel)?.isHidden = true
            (storeView as? UILabel)?.isHidden = true
        }

        if let starRating = nativeAd.starRating() {
            let filledStars = String(repeating: "\u{2605}", count: Int(starRating))
            let emptyStars = String(repeating: "\u{2606}", count: 5 - Int(starRating))
//            (starRatingView as? UIImageView)?.text = filledStars + emptyStars
            (bodyView as? UILabel)?.isHidden = true
            (starRatingView as? UIImageView)?.isHidden = false
        } else {
            (starRatingView as? UIImageView)?.isHidden = true
            (bodyView as? UILabel)?.text = nativeAd.body()
            (bodyView as? UILabel)?.isHidden = false
        }

        mediaView?.mediaContent = nativeAd.mediaContent().getMediaContent()
        
        self.nativeAd = nativeAd.getNativeAd()
    }

    func addHorizontalConstraintsToSuperviewWidth() {
        guard let superview = superview else { return }
        let child = self
        superview.addConstraints([
            NSLayoutConstraint(item: child,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: superview,
                               attribute: .leading,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: child,
                               attribute: .trailing,
                               relatedBy: .equal,
                               toItem: superview,
                               attribute: .trailing,
                               multiplier: 1,
                               constant: 0)
        ])
    }

    func addVerticalCenterConstraintToSuperview() {
        guard let superview = superview else { return }
        let child = self
        superview.addConstraint(NSLayoutConstraint(item: superview,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: child,
                                                   attribute: .centerY,
                                                   multiplier: 1,
                                                   constant: 0))
    }

    static func colorFromHexString(_ hexString: String) -> UIColor? {
        guard hexString.range(of: "^#[0-9a-fA-F]{6}$", options: .regularExpression) != nil else {
            return nil
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString.trimmingCharacters(in: CharacterSet(charactersIn: "#"))).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
    
    private func addConstraintsToRootView() {
        guard let rootView = rootView else { return }
        rootView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            NSLayoutConstraint(item: rootView,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .leading,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: rootView,
                               attribute: .trailing,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .trailing,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: rootView,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .top,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: rootView,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .bottom,
                               multiplier: 1,
                               constant: 0)
        ])
    }
}
