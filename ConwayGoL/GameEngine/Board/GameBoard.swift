//
//  GameBoard.swift
//  ConwayGoL
//
//  Created by Cody Morley on 9/22/20.
//

import Foundation

struct GameBoard: CustomStringConvertible {
    //MARK: - Properties -
    private var cells = [Point : Cell]()
    private(set) var width: Int = 1
    private(set) var height: Int = 1
    private(set) var pop: Int = 0
    var infinite: Bool = true
    
    
    //MARK: - Inits -
    init(width: Int = 1, height: Int = 1) {
        self.width = width
        self.height = height
        self.forEach { cells[$0] = .dead }
    }
    
    
    //MARK: - Subscript and String Convertible -
    subscript(_ point: Point) -> Cell {
        get { cells[wrapPoint(point), default: .dead] }
        set { cells[wrapPoint(point)] = newValue }
    }
    
    subscript(_ x: Int, _ y: Int) -> Cell? {
        get { cells[Point(x: x, y: y)] }
    }
    
    var description: String {
        self.as2DString
    }
    
    var as2DString: String {
        var output = ""
        for y in 0..<height {
            for x in 0..<width {
                output += (cell(at: Point(x: x, y: y))?.isAlive == true) ? "O" : " "
            }
            output += "\n"
        }
        return output
    }
    
    
    //MARK: - Update Board State -
    func newGenerationChanges() -> Set<Point> {
        self.compactMapToSet { point in
            let cellIsAlive = self[point].isAlive
            var count = 0
            var cellWillLive: Bool = false
            for neighbor in point.neighbors {
                if self[neighbor].isAlive == true {
                    count += 1
                } else { continue }
                
                if count == 3 || (cellIsAlive && count == 2) {
                    cellWillLive = true
                } else if count >= 4 || (cellIsAlive && count >= 3) {
                    cellWillLive = false
                    break
                }
            }
            return cellIsAlive != cellWillLive ? point : nil
        }
    }
    
    mutating func apply(_ changes: Set<Point>) {
        changes.forEach { point in
            let cell = self[point]
            pop += cell.isDead ? 1 : -1
            cells[point] = cell.toggled()
        }
    }
    
    mutating func resize(forNewWidth newWidth: Int, newHeight: Int) {
        guard newWidth != width || newHeight != height
        else { return }
        width = newWidth
        height = newHeight
        pop = 0
        self.forEach { point in
            guard self.contains(point: point) else {
                self.cells[point] = nil
                return
            }
            let cell = cells[point] ?? .dead
            cells[point] = cell
            if cell.isAlive {
                pop += 1
            }
        }
    }
    
    
    //MARK: - Navigate Board State -
    func contains(point: Point) -> Bool {
        (0..<width).contains(point.x) && (0..<height).contains(point.y)
    }
    
    func cell(at point: Point) -> Cell? {
        guard self.contains(point: wrapPoint(point)) else { return nil }
        return cells[point]
    }
    
    mutating func toggleCell(at point: Point) {
        let p = wrapPoint(point)
        guard self.contains(point: p) else {
            cells[point] = nil
            return
        }
        self[p] = self[p].toggled()
        if self[p].isAlive {
            pop += 1
        } else {
            pop -= 1
        }
    }
    
    mutating func setCell(_ cell: Cell, for point: Point) {
        let p = wrapPoint(point)
        guard self.contains(point: p) else {
            cells[p] = nil
            return
        }
        let oldCell = self[point]
        self[point] = cell
        guard oldCell != cell else { return }
        pop += cell.isAlive ? 1 : -1
    }
    
    func wrapPoint(_ point: Point) -> Point {
        guard infinite else { return point }
        var p = point
        
        while p.x < 0 {
            p.x += width
        }
        while p.y < 0 {
            p.y += height
        }
        while p.x >= width {
            p.x -= width
        }
        while p.y >= height {
            p.y -= height
        }
        
        return p
    }
}


