//
//  OrderClosed.swift
//  FOREXtrading
//
//  Created by Igor Povzyk on 15.11.2017.
//  Copyright © 2017 FOREXtradingLLC. All rights reserved.
//

import Foundation

open class OrderClosed: NSObject {
    var processedOrder:Order?
    
    public init(withOrder order:Order) {
        self.processedOrder = order
    }
    
}
