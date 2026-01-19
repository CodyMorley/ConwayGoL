//
//  Vector+GetNeighbors.swift
//  ConwayGoL
//
//  Created by Cody Morley on 9/22/20.
//

import Foundation

extension Vector {
    static var home: Vector { Vector(x: 0, y: 0) }
    static var uU: Vector { Vector(x: 0, y: -1) }
    static var dD: Vector { Vector(x: 0, y: 1) }
    static var lL: Vector { Vector(x: -1, y: 0) }
    static var rR: Vector { Vector(x: 1, y: 0) }
    static var uL: Vector { Vector(x: -1, y: -1) }
    static var uR: Vector { Vector(x: 1, y: -1) }
    static var dL: Vector { Vector(x: -1, y: 1) }
    static var dR: Vector { Vector(x: 1, y: 1) }
    static var neighborhood: Set<Vector> { [.uU, .uR, .rR, .dR, .dD, .dL, .lL, .uL] }
    
    var neighbors: Set<Vector> { Set(Self.neighborhood.lazy.map { self + $0 }) }
}
