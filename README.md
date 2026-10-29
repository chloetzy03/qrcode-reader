# qrcode-reader

An iOS app that reads QR codes.

## Requirements

- Xcode
- [Homebrew](https://brew.sh)
- [Carthage](https://github.com/Carthage/Carthage)

## Dependencies

Managed with Carthage (see [Cartfile](Cartfile) and [Cartfile.resolved](Cartfile.resolved)):

| Library | Purpose |
|---|---|
| [Alamofire](https://github.com/Alamofire/Alamofire) | HTTP networking |
| [RxSwift](https://github.com/ReactiveX/RxSwift) | Reactive programming |
| RxCocoa | RxSwift extensions for UIKit |
| RxRelay | `BehaviorRelay` and `PublishRelay` (required by RxCocoa) |

## Setup

```bash
git clone https://github.com/<your-username>/qrcode-reader.git
cd qrcode-reader
brew install carthage    # skip if already installed
carthage bootstrap --use-xcframeworks --platform iOS
```

Then open `qrcode-reader.xcodeproj` and build.

`bootstrap` builds the exact versions pinned in `Cartfile.resolved`. Run `carthage update --use-xcframeworks --platform iOS` only when you want newer versions allowed by the `Cartfile`.
