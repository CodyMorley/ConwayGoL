//
//  GameBoard+Random.swift
//  ConwayGoL
//
//  Created by Cody Morley on 9/22/20.
//

import Foundation

// MARK: - Random Board -
extension GameBoard {
    static func random<RNG: RandomNumberGenerator>(width: Int = defaultSize,
                                                   height: Int = defaultSize,
                                                   density: Double = 0.5,
                                                   gen: inout RNG) -> GameBoard {
        let density = density > maxDensity ? maxDensity : density
        let totalCells = Double(width * height)
        let populatedCells = Int(density * totalCells)
        var board = GameBoard(width: width,
                            height: height)
        
        
        func newPoint() -> Point {
            return Point(
                x: Int.random(in: 0..<width,
                              using: &gen),
                y: Int.random(in: 0..<height,
                              using: &gen))
        }
        
        for _ in 0..<populatedCells {
            var point = newPoint()
            while board.cell(at: point) == .alive {
                point = newPoint()
            }
            board.setCell(.alive,
                        for: point)
        }
        return board
    }
    
    static func random(width: Int = defaultSize,
                       height: Int = defaultSize,
                       density: Double = 0.5,
                       seed: UInt64? = nil) -> GameBoard {
        
        var r: CAMRandom
        
        if let seed = seed {
            r = CAMRandom(seed: seed)
        } else {
            r = CAMRandom()
        }
        return random(width: width,
                      height: height,
                      density: density,
                      gen: &r)
    }
}
