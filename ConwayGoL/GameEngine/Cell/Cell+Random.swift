//
//  Cell+Random.swift
//  ConwayGoL
//
//  Created by Cody Morley on 9/22/20.
//

import Foundation

extension Cell {
    static func random<RNG: RandomNumberGenerator>(liveChance: Double = 0.5, using rng: inout RNG) -> Cell {
        let deadness = Double.random(in: 0...1, using: &rng)
        
        if deadness < liveChance {
            return .alive
        } else {
            return .dead
        }
    }
    
    static func random(liveChance: Double = 0.5) -> Cell {
        var rando = CAMRandom()
        
        return random(liveChance: liveChance, using: &rando)
    }
}
