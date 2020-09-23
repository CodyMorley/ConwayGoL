//
//  Atomic.swift
//  ConwayGoL
//
//  Created by Cody Morley on 9/22/20.
//

import Foundation

@propertyWrapper
class Atomic<Value> {
    //MARK: - Properties -
    var wrappedValue: Value {
        get { queue.sync { value } }
        set { queue.sync { value = newValue } }
    }
    private var value: Value
    private lazy var queue: DispatchQueue = {
        let gol = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String
        return DispatchQueue(label: "\(gol).AtomicQueue.\(Value.self)")
    }()
    
    
    //MARK: - Inits -
    init(wrappedValue: Value) {
        self.value = wrappedValue
    }
}
