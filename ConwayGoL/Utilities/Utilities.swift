//
//  Utilities.swift
//  ConwayGoL
//
//  Created by Cody Morley on 9/22/20.
//

import SwiftUI

//MARK: - Extensions -
extension Optional where Wrapped: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        guard let lhs = lhs, let rhs = rhs
        else { return false }
        return lhs < rhs
    }
}


extension BinaryFloatingPoint {
    func clamped(to clamp: Self) -> Self {
        (self > clamp) ? clamp : self
    }
}

extension UIColor {
    convenience init(light: @autoclosure @escaping () -> UIColor,
                     dark: @autoclosure @escaping () -> UIColor,
                     defaultsToLight: Bool = true) {
        self.init { traits -> UIColor in
            let defaultColor = defaultsToLight ? light : dark
            
            switch traits.userInterfaceStyle {
            case .light:
                return light()
            case .dark:
                return dark()
            default:
                return defaultColor()
            }
        }
    }
}

extension ColorScheme {
    var opposite: ColorScheme {
        switch self {
        case .dark: return .light
        default: return .dark
        }
    }
    
    var color: Color {
        self == .dark ? .black : .white
    }
    
    var uiColor: UIColor {
        self == .dark ? .black : .white
    }
}


//MARK: - Global Functions -
@discardableResult func configure<T>(_ value: T, with changes: (inout T) throws -> Void) rethrows -> T {
    var value = value
    try changes(&value)
    return value
}

func undefined<T>(_ message: String = "") -> T {
    fatalError("Undefined: \(message)")
}
