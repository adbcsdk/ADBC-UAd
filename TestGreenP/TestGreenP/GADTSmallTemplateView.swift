//
//  File.swift
//  TestGreenP
//
//  Created by 신아람 on 1/23/24.
//

import UAdFramework

class GADTSmallTemplateView: UAdNativeAdView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func getTemplateTypeName() -> String {
        return "small_template"
    }
}
