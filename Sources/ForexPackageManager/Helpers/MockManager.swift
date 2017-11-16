//
//  CSVHelper.swift
//  FOREXtrading
//
//  Created by Igor Povzyk on 15.11.2017.
//  Copyright © 2017 FOREXtradingLLC. All rights reserved.
//

import CSwiftV
import RxSwift
import Foundation

open class MockManager: NSObject,IMockManager {
    
    // MARK - Public properties section
    //___________________________________
    
    /// Used to access/subscribe to new event when new order arrives
    public var orders:Observable<Order> {
        return ordersSubject.asObservable()
    }
    
    
    
    // MARK - Private properties section
    //___________________________________
    
    /// Used to generate new event when new order arrives
    private var ordersSubject = PublishSubject<Order>()
    
    
    // MARK - Public functions section
    //___________________________________
    
    /// Generates mock data flow
    open func processOrders() {
        let data = loadCSV()
        data.map({Order(withDict: $0)}).filter({$0 != nil}).forEach({ordersSubject.onNext($0!)})
    }
    
    
    
    
    // MARK - Private functions section
    //___________________________________
    
    /// Loads and parses data from CSV file
    ///
    /// - Returns: Array of dictionary data for Order model
    private func loadCSV() -> [[String:String]] {
        var inputString:String? = nil
        if let path = Bundle(for: self.classForCoder).path(forResource: "RawData", ofType: "csv") {
            let url = URL(fileURLWithPath: path)
            do {
                inputString = try String(contentsOf: url, encoding: .utf8)
                let csv = CSwiftV(with: inputString!)
                return csv.keyedRows ?? [[:]]
            }
            catch {
                fatalError("Project data is corrupted")
            }
        }
        fatalError("Project data is corrupted")
    }
    
}
