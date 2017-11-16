//
//  ForexEngine.swift
//  FOREXtrading
//
//  Created by Igor Povzyk on 15.11.2017.
//  Copyright © 2017 FOREXtradingLLC. All rights reserved.
//

import RxSwift
import Foundation

class ForexEngine: IForexEngine {
    
    // MARK - Public properties section
    //___________________________________
    
    /// Used to produce events for orders placing
    public var placedOrders: Observable<OrderPlaced> {
        return placedOrdersSubject.asObservable().share()
    }
    
    /// Used to produce events for orders closing
    public var closedOrders: Observable<OrderClosed> {
        return closedOrdersSubject.asObservable().share()
    }
    
    
    
    // MARK - Private properties section
    //___________________________________
    fileprivate let placedOrdersSubject = PublishSubject<OrderPlaced>()
    fileprivate let closedOrdersSubject = PublishSubject<OrderClosed>()
    fileprivate let bag = DisposeBag()
    fileprivate lazy var orders = [Order]()
    fileprivate var ordersDataSource:Observable<Order>?
    
    
    
    // MARK - Public functions section
    //___________________________________
    
    /// Subscribes Engine to ordersDataSource
    ///
    /// - Parameter source: new datasource
    /// - Returns: true if datasorce is assigned, false if Engine already has datasource
    public func subscribeToDataSourse(ordersDataSource source:Observable<Order>) -> Bool {
        if ordersDataSource == nil {
            ordersDataSource = source
            ordersDataSource?.subscribe { [weak self] (order) in
                if let element = order.element {
                    self?.orders.append(element)
                    self?.placedOrdersSubject.onNext(OrderPlaced(withOrder: element))
                    NSLog("New order recieved:\n\(element.description)")
                    self?.findMatch(forOrder: element)
                }
                }.disposed(by: bag)
            return true
        }
        else {
            return false
        }
    }
    
    
    /// Looks for matching order in current orders array
    ///
    /// - Parameter order: new order to be processed
    private func findMatch(forOrder order:Order){
        orders.forEach({
            if ($0.matches(anotherOrder: order)){
                NSLog("Match found: \n\($0)-----WITH----- \n\(order)")
                updateAmountAndStatus(forFirstOrder: $0, secondOrder: order)
            }
        })
    }
    
    
    /// Updates orders according to deal amount. Closes order which is fully completed
    ///
    /// - Parameters:
    ///   - first: existing order
    ///   - second: new incoming order
    private func updateAmountAndStatus(forFirstOrder first:Order,secondOrder second:Order) {
        let biggerOrder = first.amount >= second.amount ? first : second
        let lesserOrder = first.amount < second.amount ? first : second
        lesserOrder.status = .closed
        closedOrdersSubject.onNext(OrderClosed(withOrder: lesserOrder))
        biggerOrder.amount -= lesserOrder.amount
        if biggerOrder.amount == 0 {
            biggerOrder.status = .closed
            closedOrdersSubject.onNext(OrderClosed(withOrder: biggerOrder))
        }
    }
}
