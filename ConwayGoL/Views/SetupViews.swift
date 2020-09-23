//
//  SetupViews.swift
//  ConwayGoL
//
//  Created by Cody Morley on 9/23/20.
//

import SwiftUI

struct SizeSetupView: View {
    //MARK: - Size Setup Types -
    private enum SliderType: String {
        case width, height
        
    }
    
    
    //MARK: -Size Setup Properties-
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var gameEngine: GameEngine
    @State private var newWidth: Double
    @State private var newHeight: Double
    @Binding private var visibleGrid: Bool
    private let widthHeightFormatter = configure(NumberFormatter()) {
        $0.minimum = GameBoard.minSize as NSNumber
        $0.maximum = GameBoard.maxSize as NSNumber
        $0.maximumFractionDigits = 0
    }
    
    
    //MARK: - Size Setup Inits -
    init(gameEngine: GameEngine, visibleGrid: Binding<Bool>) {
        self.gameEngine = gameEngine
        self._newWidth = State(initialValue: Double(gameEngine.board.width))
        self._newHeight = State(initialValue: Double(gameEngine.board.height))
        self._visibleGrid = visibleGrid
    }
    
    
    //MARK: - Size Setup Body -
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Toggle(isOn: self.$visibleGrid) {
                    Text("Show grid")
                }
            }
            HStack {
                Toggle(isOn: self.$gameEngine.infinite) {
                    Text("Grid wraps")
                }
            }
            slider(for: .width)
            slider(for: .height)
        }.padding()
    }
    
    
    //MARK: - Size Setup Methods -
    private func slider(for type: SliderType) -> some View {
        let binding: Binding<Double> = {
            switch type {
            case .width: return $newWidth
            case .height: return $newHeight
            }
        }()
        return HStack {
            Text("\(type.rawValue.capitalized):")
            Slider(value: binding, in: Double(GameBoard.minSize)...Double(GameBoard.maxSize), step: 1) { (_) in
                self.resizeBoard()
            }
            Text(widthHeightFormatter
                    .string(from: NSNumber(value: binding.wrappedValue))!)
        }
    }
    
    func resizeBoard() {
        self.gameEngine.resizeBoard(
            width: Int(self.newWidth),
            height: Int(self.newHeight))
    }
}



//MARK: - Population Controls -
struct PopulationControls: View {
    //MARK: - Pop Controls Properties -
    @ObservedObject var gameEngine: GameEngine
    @State private var density: Double = 0.5
    
    init(gameEngine: GameEngine) {
        self.gameEngine = gameEngine
    }
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Text("Density:")
                    Slider(value: $density, in: 0...GameBoard.maxDensity)
                }.padding()
                
                HStack {
                    Button(action: {
                        self.gameEngine.randomize(density: self.density)
                    }) {
                        Text("Randomize")
                    }
                    Button(action: gameEngine.clear) {
                        Text("Clear")
                    }
                }
            }
        }.buttonStyle(LifeButtonStyle())
    }
}



// MARK: - Previews
struct SizeSetupView_Previews: PreviewProvider {
    static var previews: some View {
        SizeSetupView(gameEngine: GameEngine(
                        board: GameBoard(width: 25,
                                         height: 25)),
                        visibleGrid: Binding(get: { return true },
                                             set: { _ in }))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

struct PopulationControls_Previews: PreviewProvider {
    static var previews: some View {
        PopulationControls(gameEngine: GameEngine())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}


