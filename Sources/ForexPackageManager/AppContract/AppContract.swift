//
//  AppContract.swift
//  FOREXtrading
//
//  Created by Igor Povzyk on 15.11.2017.
//  Copyright © 2017 FOREXtradingLLC. All rights reserved.
//

import RxSwift

protocol IForexEngine {
    var placedOrders: Observable<OrderPlaced> {get}
    var closedOrders: Observable<OrderClosed> {get}
    func subscribeToDataSourse(ordersDataSource source:Observable<Order>) -> Bool
}

protocol IMockManager {
    var orders:Observable<Order> {get}
    func processOrders()
}
