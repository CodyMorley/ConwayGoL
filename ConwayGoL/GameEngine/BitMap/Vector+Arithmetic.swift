//
//  Vector+Arithmetic.swift
//  ConwayGoL
//
//  Created by Cody Morley on 9/22/20.
//

import Foundation

extension Vector {
    static func + (lhs: Vector, rhs: Vector) -> Vector {
        Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func - (lhs: Vector, rhs: Vector) -> Vector {
        Vector(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func * (lhs: Vector, rhs: Vector) -> Vector {
        Vector(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }
    
    static func / (lhs: Vector, rhs: Vector) -> Vector {
        Vector(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }
}
