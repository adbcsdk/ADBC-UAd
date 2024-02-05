//
//  UAdMediaContent.swift
//  
//  Created by 신아람 on 1/18/24.
//

import GoogleMobileAds

public class UAdMediaContent {
    private let mediaContent: GADMediaContent
    
    init(mediaContent: GADMediaContent) {
        self.mediaContent = mediaContent
    }
    
    public func getMediaContent() -> GADMediaContent {
        return mediaContent
    }
}
