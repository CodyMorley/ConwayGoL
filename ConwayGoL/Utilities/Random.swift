//
//  Random.swift
//  ConwayGoL
//
//  Created by Cody Morley on 9/22/20.
//

import Foundation

fileprivate let multiplier: UInt64 = 6364136223846793005
fileprivate let increment: UInt64 = 1442695040888963407


public extension Collection where Index == Int {
    func randomElement<RNG: RandomNumberGenerator>(using rng: inout RNG) -> Element? {
        if isEmpty { return nil }
        return self[startIndex + Index(rng.next() % UInt64(count))]
    }
}

public struct CAMRandom: RandomNumberGenerator {
    //MARK: - Properties -
    private(set) var seed: UInt64
    
    //MARK: - Inits -
    public init(seed: UInt64 = .random(in: 0..<UInt64.max)) {
        self.seed = seed
    }
    
    //MARK: - Methods -
    public mutating func next() -> UInt64 {
        seed = seed &* multiplier &+ increment
        return seed
    }
}



