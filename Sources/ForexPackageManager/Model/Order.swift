//
//  Order.swift
//  FOREXtrading
//
//  Created by Igor Povzyk on 15.11.2017.
//  Copyright © 2017 FOREXtradingLLC. All rights reserved.
//

import Foundation

public enum Currency:String {
    case USD = "USD"
    case EUR = "EUR"
}

public enum Side:String {
    case buy = "BUY"
    case sell = "SELL"
}

public enum Status {
    case open
    case closed
}

public class CurrencyPair {
    var first:Currency
    var second:Currency
    
    init(first:Currency,second:Currency) {
        self.first = first
        self.second = second
    }
}

open class Order:NSObject {
    
    public static var idCounter:Int = 0 // Internal static property to handle id autogeneration. Public in order to reset id's
    
    open override var description: String {
        return "id - \(id)\n" +
            "currencyPair - \(currencyPair.first)/\(currencyPair.second)\n" +
        "amount - \(amount)\n" +
        "price - \(price)\n" +
        "side - \(side)\n" +
        "status - \(status)\n"
    }
    
    public var id:Int // autogenerated id
    public var currencyPair:CurrencyPair //trading pair e.g. USD/EUR
    public var amount:Float //the amount of order e.g. 100
    public var price:Float // the price one of counter parties is willing to pay for given amount
    public var side:Side //Buy or Sell
    public var status:Status //
    
    required public init?(withDict dict:[String:String]) {
        
        if let firstCurrencyPair =  Currency(rawValue: dict["CurrencyPair"]?.components(separatedBy: "/").first ?? ""),
            let secondCurrencyPair =  Currency(rawValue: dict["CurrencyPair"]?.components(separatedBy: "/").last ?? ""),
            let amount = Float(dict["Amount"] ?? ""), let price = Float(dict["Price"] ?? ""),
            let side = Side(rawValue: dict["Side"] ?? ""){
            
            self.currencyPair = CurrencyPair(first: firstCurrencyPair, second: secondCurrencyPair)
            self.amount = amount
            self.price = price
            self.side = side
            self.id = Order.idCounter
            Order.idCounter += 1
            self.status = .open
        }
        else {
            return nil
        }
        super.init()
    }
    
    
//    Order matching
//    Order can match ONLY
//    - orders have the same CurrencyPair
//    - orders have opposite Side e.g. Buy order can match with Sell and vice versa
//    - Buy order can be matched with Sell order, which have Price equal or lower than Buy order price
//    - Sell order can be matched with Buy order, which have Price equal or more than Sell order price

    func matches(anotherOrder order:Order) -> Bool {
        return self.currencyPair.first == order.currencyPair.first && self.currencyPair.second == order.currencyPair.second &&
               self.side != order.side &&
               (self.side == .buy && order.price <= self.price ||
               self.side == .sell && order.price >= self.price ) &&
               self.status != .closed && order.status != .closed
    }
    
}
