//
//  Cell+States.swift
//  ConwayGoL
//
//  Created by Cody Morley on 9/22/20.
//

import Foundation

extension Cell {
    var isDead: Bool { self == .dead }
    var isAlive: Bool { self == .alive }
    
    mutating func toggle() {
        self = (self == .alive) ? .dead : .alive
    }
    
    func toggled() -> Cell {
        return (self == .alive) ? .dead : .alive
    }
}
