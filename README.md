# DelegateCenter

[![CI Status](https://img.shields.io/travis/install-b/DelegateCenter.svg?style=flat)](https://travis-ci.org/install-b/DelegateCenter)
[![Version](https://img.shields.io/cocoapods/v/DelegateCenter.svg?style=flat)](https://cocoapods.org/pods/DelegateCenter)
[![License](https://img.shields.io/cocoapods/l/DelegateCenter.svg?style=flat)](https://cocoapods.org/pods/DelegateCenter)
[![Platform](https://img.shields.io/cocoapods/p/DelegateCenter.svg?style=flat)](https://cocoapods.org/pods/DelegateCenter)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.



subscript protocol

```Swift
/// Protocol Way
// declare Protocol
@objc protocol XXXProtocol {
    func aMethod()
}

// on subscribe
DelegateCenter.default.add(self as XXXProtocol)

// cancel subscribe
DelegateCenter.default.remove(self as XXXProtocol)



// send message
DelegateCenter.default.enumDelegate(XXXProtocol.self) { (delegate, _) in
    delegate.aMethod()
}
        
/// Abstract Class Way
// declare Abstract Class
class AClass {
    open func aMethod() {

    }
}

/// 
class SubAClass: AClass {
    overrite func aMethod() {
        // sub Class implemention
    }
}

let aInstance = SubAClass()
DelegateCenter.default.add(aInstance as AClass)


// send message
DelegateCenter.default.enumDelegate(AClass.self) { (delegate, _) in
    delegate.aMethod()
}
        
```

## Requirements

## Installation

DelegateCenter is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DelegateCenter'
```

## Author

install-b, 645256685@qq.com

## License

DelegateCenter is available under the MIT license. See the LICENSE file for more info.


