//
//  FOREXtradingTests.swift
//  FOREXtradingTests
//
//  Created by Igor Povzyk on 15.11.2017.
//  Copyright © 2017 FOREXtradingLLC. All rights reserved.
//

import XCTest
import RxSwift
@testable import ForexPackageManager

class FOREXtradingTests: XCTestCase {
    
    var engine:IForexEngine!
    var helper:IMockManager!
    var bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        engine = ForexEngine()
        helper = MockManager()
    }
    
    override func tearDown() {
        Order.idCounter = 0
        super.tearDown()
    }
    
    // MARK - Tests MockManager for proper Order count generation Should pass
    func testCSVLoadingAndEventProducing() {
        var number = 0
        helper.orders.subscribe {
            (event) in
            number += 1
        }.disposed(by: bag)
        helper.processOrders()
        XCTAssertTrue(number == 6)
    }

    
    func testEngingeClosed() {
        let result = engine.subscribeToDataSourse(ordersDataSource: helper.orders)
        XCTAssertTrue(result)
        var firstFound = false
        var secondFound = false
        var thirdFound = false
        engine.closedOrders.subscribe {
            (event) in
            if event.element!.processedOrder!.id == 1 {firstFound = true}
            if event.element!.processedOrder!.id == 4 {secondFound = true}
            if event.element!.processedOrder!.id == 5 {thirdFound = true}
        }.disposed(by: bag)
        helper.processOrders()
        XCTAssertTrue(firstFound&&secondFound&&thirdFound)
    }
    
    func testEnginePlaced() {
        var count = 0
        let result = engine.subscribeToDataSourse(ordersDataSource: helper.orders)
        XCTAssertTrue(result)
        engine.placedOrders.subscribe {
            (event) in
            count += 1
            }.disposed(by: bag)
        helper.processOrders()
        XCTAssertTrue(count == 6)
    }
    
    func testEngineDataSource(){
        let resultTrue = engine.subscribeToDataSourse(ordersDataSource: helper.orders)
        XCTAssertTrue(resultTrue)
        let resultFalse = engine.subscribeToDataSourse(ordersDataSource: helper.orders)
        XCTAssertFalse(resultFalse)
    }
    
    func testOrderFail() {
        let order = Order(withDict: ["Side":"BUY","CurrencyPair":"EUR/USD"])
        XCTAssertNil(order)
    }
    
    func testOrderSuccess(){
        let order = Order(withDict: ["Side":"BUY","CurrencyPair":"EUR/USD","Amount":"50","Price":"50"])
        XCTAssertNotNil(order)
    }
    
}
