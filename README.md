![RunKit](https://raw.githubusercontent.com/khoiln/RunKit/master/Assets/runkit.png)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/RunKit.svg)](https://cocoapods.org/pods/RunKit) 
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![](http://img.shields.io/badge/Swift-2.1-blue.svg)](https://developer.apple.com/swift/) 
[![](https://img.shields.io/cocoapods/p/RunKit.svg?style=flat)](https://cocoapods.org/pods/RunKit) 
[![](https://img.shields.io/dub/l/vibe-d.svg)](https://github.com/khoiln/RunKit/blob/master/LICENSE)

A Swift Wrapper for libdispatch aka Grand Central Dispatch (GCD) Framework that supports method chaining. 

Tired of this?
```swift
dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) { () -> Void in
    for index in 1...UInt64.max{
        print(index)
    }
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        print("Back to main thread")
    })
}
```
With RunKit
```swift
Run.background { 
    for index in 1...UInt64.max{
        print(index)
    }
}.main { 
    print("Back to main thread")
}
```
## Installation
### Cocoapods
Add this to your Podfile
```ruby
pod 'RunKit', '~> 1.0'
```
### Carthage
Add this to your Cartfile
```ruby
github "khoiln/RunKit"
```
## Usage
Supported Queues:
```swift
Run.main {}
Run.userInteractive {}
Run.userInitiated {}
Run.utility {}
Run.background {}
```
Queues Chaining:
```swift
Run.main { 
    print("main queue")
}.background { 
    print("background queue")
}.userInitiated {
    print("userInitiated queue")
}.main { 
    print("Back to main thread")
}
```
Using Custom Queue:
```swift
let queue = dispatch_queue_create("queue1", DISPATCH_QUEUE_SERIAL)
Run.custom(queue: queue){
    print("User created Queue")
}
```
Store blocks reference for chaining
```swift
let longRunningBlock = Run.background{
    for index in 1...UInt64.max{
        print(index)
    }
}
longRunningBlock.main{
    print("Back to main thread")
}
```
You can also cancel a running process
```swift
longRunningBlock.cancel()
```
Or wait for it to finish
```swift
longRunningBlock.wait()
print("Continue..")
```

## License
RunKit is released under the MIT license. See [LICENSE](https://github.com/khoiln/RunKit/blob/master/LICENSE) for details.

