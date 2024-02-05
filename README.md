## GreenPFramework

## Version 1.0.5
- Swift version 5.8
- Minimum iOS version 14.0

## Installation
UAdFramework support [Swift Package Manager](https://www.swift.org/package-manager/)
1. File -> Add Packages...
2. Find Package With Url - "https://github.com/adbcsdk/ADBC-UAd.git"
3. Enable the `-ObjC` flag in Xcode: select Build Settings, search for Other Linker Flags and add `-ObjC`.

## Info.plist
광고 추적 권한<br>
<img width="1234" alt="스크린샷 2023-11-21 오후 9 05 22" src="https://i.imgur.com/mSqChu7.png">
<br>http 통신 예외처리<br>
<img width="803" alt="스크린샷 2023-11-21 오후 9 08 45" src="https://i.imgur.com/W43n4Oc.pnga">
<br>GADApplicationIdentifier 등록<br>
<br>SKAdNetworkItems 등록<br>

## Initialize
```swift
import UAdFramework

// Framework 초기화
override func viewDidLoad() {
    super.viewDidLoad()
    UAdMobileAds.shared().initialize(appID: "Your App Id", userID: "user ID", isDebug: false, completion: { result, msg in
        print("init result = \(result), msg = \(msg)")
    })
}

// 세부 사용방법은 샘플 프로젝트 참조

```
