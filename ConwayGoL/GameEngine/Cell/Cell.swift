//
//  Cell.swift
//  ConwayGoL
//
//  Created by Cody Morley on 9/22/20.
//

import Foundation

enum Cell: UInt8, CaseIterable {
    case dead
    case alive
    
    init<I: BinaryInteger>(safe rawValue: I) {
        if let cell = Cell(rawValue: UInt8(rawValue)) {
            self = cell
        } else {
            self = Cell(safe: abs(Int(rawValue)) % Self.allCases.count)
        }
    }
}
