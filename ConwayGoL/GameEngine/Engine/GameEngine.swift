//
//  GameEngine.swift
//  ConwayGoL
//
//  Created by Cody Morley on 9/22/20.
//

import Foundation
import Combine
import UIKit

class GameEngine: ObservableObject {
    //MARK: - Properties -
    @Published var board: GameBoard {
        didSet { buffer = board }
    }
    @Published private(set) var generation: Int = 0
    @Published private(set) var isRunning: Bool = false
    @Published private(set) var actualFrameRate: Double = 0
    @Published var infinite: Bool {
        didSet {
            board.infinite = infinite
            buffer.infinite = infinite
        }
    }
    var framerateRange: ClosedRange<Double> { 1...20 }
    var requestedFramerate: Double = 2 {
        didSet { deltaTimeThreshold = getDeltaTimeThreshold() }
    }
    private let updateThread = DispatchQueue.global()
    private var buffer: GameBoard
    private var lastUpdateTime = CFAbsoluteTimeGetCurrent()
    private lazy var deltaTimeThreshold = getDeltaTimeThreshold()
    
    //MARK: - Inits -
    init(board: GameBoard = .init(width: GameBoard.defaultSize,
                                  height: GameBoard.defaultSize)) {
        self.board = board
        self.buffer = board
        self.infinite = board.infinite
    }
    
    
    //MARK: --GAME AI CONTROL--
    //MARK: - API -
    func resizeBoard(width: Int, height: Int) {
        board.resize(forNewWidth: width, newHeight: height)
        buffer = board
    }
    
    func clear() {
        board = GameBoard(width: board.width, height: board.height)
        board.infinite = infinite
        generation = 0
    }
    
    func randomize(density: Double) {
        board = GameBoard.random(width: board.width, height: board.height, density: density)
        board.infinite = infinite
        generation = 0
    }
    
    func toggleRunning() {
        isRunning ? stop() : start()
    }
    
    func advanceGeneration() {
        updateThread.async { self.update() }
    }
    
    
    //MARK: - Loop -
    func start() {
        guard !isRunning else { return }
        isRunning = true
        main()
    }
    
    func stop() {
        isRunning = false
    }
    
    private func update() {
        let changes = self.buffer.newGenerationChanges()
        DispatchQueue.main.sync {
            self.board.apply(changes)
            self.generation += 1
        }
    }
    
    private func main() {
        updateThread.async { [weak self] in
            while self?.isRunning == true {
                guard let self = self else { return }
                let currentTime = CFAbsoluteTimeGetCurrent()
                let deltaTime = currentTime - self.lastUpdateTime
                
                if deltaTime < self.deltaTimeThreshold { continue }
                
                self.lastUpdateTime = currentTime
                
                let computedFramerate = 1 / deltaTime
                
                DispatchQueue.main.async { self.actualFrameRate = computedFramerate }
                DispatchQueue.global().sync { self.update() }
            }
        }
    }
    
    
    //MARK: - Timing -
    private func getDeltaTimeThreshold() -> Double {
        CFAbsoluteTime(exactly: 1 / Double(requestedFramerate)) ?? 1
    }
}
