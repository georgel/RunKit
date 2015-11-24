//
//  RunKitTests.swift
//  RunKitTests
//
//  Created by Khoi on 11/24/15.
//  Copyright © 2015 Khoi. All rights reserved.
//

import XCTest
@testable import RunKit

class RunKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: Dispatch Without Delay
    func testMainThread(){
        let expectation = expectationWithDescription("Expected running on main thread")
        var calledAsync = false
        
        Run.main { () -> Void in
            XCTAssertEqual(qos_class_self(), qos_class_main(), "Running in \(qos_class_self().description) - Expected: \(qos_class_main().description)")
            XCTAssert(calledAsync, "Should be running async")
            expectation.fulfill()
        }
        calledAsync = true
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    func testuserInteractive(){
        let expectation = expectationWithDescription("Expected Running in User Interactive Queue")
        Run.userInteractive { () -> Void in
            XCTAssertEqual(qos_class_self(), QOS_CLASS_USER_INTERACTIVE, "Running in \(qos_class_self().description) - Expected: \(QOS_CLASS_USER_INTERACTIVE.description)")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    func testuserInitiated(){
        let expectation = expectationWithDescription("Expected Running in userInitiated Queue")
        Run.userInitiated { () -> Void in
            XCTAssertEqual(qos_class_self(), QOS_CLASS_USER_INITIATED, "Running in \(qos_class_self().description) - Expected: \(QOS_CLASS_USER_INITIATED.description)")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    func testutility(){
        let expectation = expectationWithDescription("Expected Running in utility Queue")
        Run.utility { () -> Void in
            XCTAssertEqual(qos_class_self(), QOS_CLASS_UTILITY, "Running in \(qos_class_self().description) - Expected: \(QOS_CLASS_UTILITY.description)")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    func testBackground(){
        let expectation = expectationWithDescription("Expected Running in Background Queue")
        Run.background { () -> Void in
            XCTAssertEqual(qos_class_self(), QOS_CLASS_BACKGROUND, "Running in \(qos_class_self().description) - Expected: \(QOS_CLASS_BACKGROUND.description)")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    func testChaining(){
        let expectation = expectationWithDescription("Test chaining queue")
        var count = 0
        Run.main { () -> Void in
            XCTAssertEqual(qos_class_self(), qos_class_main())
            XCTAssertEqual(++count, 1)
            }.userInteractive { () -> Void in
                XCTAssertEqual(qos_class_self(), QOS_CLASS_USER_INTERACTIVE)
                XCTAssertEqual(++count, 2)
            }.userInitiated { () -> Void in
                XCTAssertEqual(qos_class_self(), QOS_CLASS_USER_INITIATED)
                XCTAssertEqual(++count, 3)
            }.utility { () -> Void in
                XCTAssertEqual(qos_class_self(), QOS_CLASS_UTILITY)
                XCTAssertEqual(++count, 4)
            }.background { () -> Void in
                XCTAssertEqual(qos_class_self(), QOS_CLASS_BACKGROUND)
                XCTAssertEqual(++count, 5)
                expectation.fulfill()
        }
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    //MARK: Dispatch With Delay Time
    func testMainThreadWithDelay(){
        let expectation = expectationWithDescription("Expected with delay")
        let date = NSDate()
        let timeDelay = 1.0
        let upperTimeDelay = timeDelay + 0.2
        Run.main(after: timeDelay) {
            let timePassed = NSDate().timeIntervalSinceDate(date)
            XCTAssert(timePassed >= timeDelay, "Should have waited for \(timeDelay) seconds")
            XCTAssert(timePassed < upperTimeDelay, "\(timePassed) seems wrong. Expected something <\(upperTimeDelay)")
            XCTAssertEqual(qos_class_self(), qos_class_main())
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(upperTimeDelay*2, handler: nil)
    }
    func testuserInteractiveWithDelay(){
        let expectation = expectationWithDescription("Expected with delay")
        let date = NSDate()
        let timeDelay = 1.0
        let upperTimeDelay = timeDelay + 0.2
        Run.userInteractive(after: timeDelay) {
            let timePassed = NSDate().timeIntervalSinceDate(date)
            XCTAssert(timePassed >= timeDelay, "Should have waited for \(timeDelay) seconds")
            XCTAssert(timePassed < upperTimeDelay, "\(timePassed) seems wrong. Expected something <\(upperTimeDelay)")
            XCTAssertEqual(qos_class_self(), QOS_CLASS_USER_INTERACTIVE)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(upperTimeDelay*2, handler: nil)
    }
    func testuserInitiatedThreadWithDelay(){
        let expectation = expectationWithDescription("Expected with delay")
        let date = NSDate()
        let timeDelay = 1.0
        let upperTimeDelay = timeDelay + 0.2
        Run.userInitiated(after: timeDelay) {
            let timePassed = NSDate().timeIntervalSinceDate(date)
            XCTAssert(timePassed >= timeDelay, "Should have waited for \(timeDelay) seconds")
            XCTAssert(timePassed < upperTimeDelay, "\(timePassed) seems wrong. Expected something <\(upperTimeDelay)")
            XCTAssertEqual(qos_class_self(), QOS_CLASS_USER_INITIATED)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(upperTimeDelay*2, handler: nil)
    }
    func testutilityWithDelay(){
        let expectation = expectationWithDescription("Expected with delay")
        let date = NSDate()
        let timeDelay = 1.0
        let upperTimeDelay = timeDelay + 0.2
        Run.utility(after: timeDelay) {
            let timePassed = NSDate().timeIntervalSinceDate(date)
            XCTAssert(timePassed >= timeDelay, "Should have waited for \(timeDelay) seconds")
            XCTAssert(timePassed < upperTimeDelay, "\(timePassed) seems wrong. Expected something <\(upperTimeDelay)")
            XCTAssertEqual(qos_class_self(), QOS_CLASS_UTILITY)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(upperTimeDelay*2, handler: nil)
    }
    
    
}
