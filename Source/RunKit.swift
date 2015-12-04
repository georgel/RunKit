//
//  RunKit.swift
//  RunKit
//
//  Created by Khoi on 9/24/15.
//  Copyright © 2015 Khoi. All rights reserved.
//

import Foundation

private enum Queue {
    static func main() -> dispatch_queue_t{
        return dispatch_get_main_queue()
    }
    static func userInteractive() -> dispatch_queue_t{
        return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
    }
    static func userInitiated() -> dispatch_queue_t{
        return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
    }
    static func utility() -> dispatch_queue_t{
        return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
    }
    static func background() -> dispatch_queue_t{
        return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    }
}

public struct Run {
    private let _block : dispatch_block_t
    private init (_ block: dispatch_block_t){
        _block = block
    }
}

//MARK: Static methods
private extension Run{
    static func execute(seconds seconds: Double?, block: dispatch_block_t, queue: dispatch_queue_t) -> Run{
        if let waitSecond = seconds{
            return executeAfter(seconds: waitSecond, block: block, queue: queue)
        }
        return executeNow(block, queue: queue)
    }
    static func executeNow(block: dispatch_block_t, queue: dispatch_queue_t) -> Run{
        let newBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, block)
        dispatch_async(queue, newBlock)
        return Run(newBlock)
    }
    static func executeAfter(seconds seconds: Double, block: dispatch_block_t, queue: dispatch_queue_t) -> Run{
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
        let newBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, block)
        dispatch_after(delayTime, queue, newBlock)
        return Run(newBlock)
    }
}
public extension Run {
    static func main(after seconds: Double? = nil, block: dispatch_block_t) -> Run{
        return execute(seconds: seconds, block: block, queue: Queue.main())
    }
    static func userInteractive(after seconds: Double? = nil, block: dispatch_block_t) -> Run{
        return execute(seconds: seconds, block: block, queue: Queue.userInteractive())
    }
    static func userInitiated(after seconds: Double? = nil, block: dispatch_block_t) -> Run{
        return execute(seconds: seconds, block: block, queue: Queue.userInitiated())
    }
    static func utility(after seconds: Double? = nil, block: dispatch_block_t) -> Run{
        return execute(seconds: seconds, block: block, queue: Queue.utility())
    }
    static func background(after seconds: Double? = nil, block: dispatch_block_t) -> Run{
        return execute(seconds: seconds, block: block, queue: Queue.background())
    }
    static func custom(after seconds: Double? = nil, queue: dispatch_queue_t, block: dispatch_block_t) -> Run{
        return execute(seconds: seconds, block: block, queue: queue)
    }
}

//MARK: Instance methods
private extension Run {
    func chain(seconds seconds: Double? = nil, block: dispatch_block_t, queue: dispatch_queue_t) -> Run{
        if let waitSeconds = seconds{
            return chainAfter(seconds: waitSeconds, block: block, queue: queue)
        }
        return chainNow(block: block, queue: queue)
    }
    func chainAfter(seconds seconds: Double, block: dispatch_block_t, queue: dispatch_queue_t) -> Run{
        let chainingBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, block)
        let chainingWrapperBlock: dispatch_block_t = {
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, queue, chainingBlock)
            
        }
        let newChainingWrapperBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, chainingWrapperBlock)
        dispatch_block_notify(_block, queue, newChainingWrapperBlock)
        return Run(chainingBlock)
    }
    func chainNow(block chainingBlock: dispatch_block_t, queue: dispatch_queue_t) -> Run{
        let newChainingBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, chainingBlock)
        dispatch_block_notify(_block, queue, newChainingBlock)
        return Run(newChainingBlock)
    }
}
public extension Run{
    func main(after seconds: Double? = nil, block: dispatch_block_t) -> Run{
        return self.chain(seconds: seconds, block: block, queue: Queue.main())
    }
    func userInteractive(after seconds: Double? = nil, block: dispatch_block_t) -> Run{
        return self.chain(seconds: seconds, block: block, queue: Queue.userInteractive())
    }
    func userInitiated(after seconds: Double? = nil, block: dispatch_block_t) -> Run{
        return self.chain(seconds: seconds, block: block, queue: Queue.userInitiated())
    }
    func utility(after seconds: Double? = nil, block: dispatch_block_t) -> Run{
        return self.chain(seconds: seconds, block: block, queue: Queue.utility())
    }
    func background(after seconds: Double? = nil, block: dispatch_block_t) -> Run{
        return self.chain(seconds: seconds, block: block, queue: Queue.background())
    }
    func custom(after seconds: Double? = nil, queue:dispatch_queue_t, block: dispatch_block_t) -> Run{
        return self.chain(seconds: seconds, block: block, queue: queue)
    }
    func cancel(){
        dispatch_block_cancel(_block)
    }
    func wait(seconds seconds: Double = 0.0) {
        dispatch_block_wait(_block, seconds != 0.0 ? dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC))) : DISPATCH_TIME_FOREVER)
    }
}

public extension qos_class_t {
    var description: String {
        get {
            switch self {
            case qos_class_main(): return "Main"
            case QOS_CLASS_USER_INTERACTIVE: return "User Interactive"
            case QOS_CLASS_USER_INITIATED: return "User Initiated"
            case QOS_CLASS_DEFAULT: return "Default"
            case QOS_CLASS_UTILITY: return "Utility"
            case QOS_CLASS_BACKGROUND: return "Background"
            case QOS_CLASS_UNSPECIFIED: return "Unspecified"
            default: return "Unknown"
            }
        }
    }
}

