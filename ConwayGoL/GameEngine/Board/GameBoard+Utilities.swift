//
//  GameBoard+Utilities.swift
//  ConwayGoL
//
//  Created by Cody Morley on 9/22/20.
//

import Foundation

//MARK: - Static Properties -
extension GameBoard {
    static var maxDensity: Double { 0.9 }
    static var defaultSize: Int { 32 }
    static var minSize: Int { 8 }
    static var maxSize: Int { 128 }
}

// MARK: - Helper Methods -
extension GameBoard {
    func forEach(_ body: (Point) throws -> Void) rethrows {
        for column in 0..<width {
            for row in 0..<height {
                try body(Point(x: column,
                               y: row))
            }
        }
    }
    
    func mapToSet<T: Hashable>(_ transform: (Point) throws -> T) rethrows -> Set<T> {
        var set = Set<T>()
        try self.forEach { point in
            set.insert(try transform(point))
        }
        return set
    }
    
    func compactMapToSet<T: Hashable>(_ transform: (Point) throws -> T?) rethrows -> Set<T> {
        var set = Set<T>()
        try self.forEach { point in
            if let item = try transform(point) {
                set.insert(item)
            }
        }
        return set
    }
}





