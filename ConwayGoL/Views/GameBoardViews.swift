//
//  GameBoardViews.swift
//  ConwayGoL
//
//  Created by Cody Morley on 9/22/20.
//

import SwiftUI

//MARK: - GameBoardView -
/// This struct defines the displayed view of a given boardstate using the model GameBoard
struct GameBoardView: View {
    @Binding var board: GameBoard
    @Binding var visibleGrid: Bool
    let isEditable: Bool
    
    var body: some View {
        GameBoardViewRepresentable(
            board: self.$board,
            visibleGrid: self.$visibleGrid,
            isEditable: isEditable)
            .aspectRatio(CGFloat(board.width) / CGFloat(board.height),
                         contentMode: .fit)
    }
}


///This struct bridges our UIKit draw implementation over to a VR for SwiftUI
struct GameBoardViewRepresentable: UIViewRepresentable {
    //MARK: - GBVRep Properties -
    @Binding var board: GameBoard
    @Binding var visibleGrid: Bool
    let isEditable: Bool
    
    
    //MARK: - GBVRep Methods -
    func makeUIView(context: Context) -> UIBoardView {
        let view = UIBoardView(board: $board)
        view.isEditable = isEditable
        view.visibleGrid = visibleGrid
        return view
    }
    
    func updateUIView(_ uiView: UIBoardView, context: Context) {
        uiView.isEditable = isEditable
        uiView.boardSize = CGSize(width: board.width,
                                  height: board.height)
        uiView.visibleGrid = visibleGrid
        uiView.setNeedsDisplay()
    }
}

///This class uses the UIKit Draw method to redraw the display in core graphics.
class UIBoardView: UIView {
    //MARK: - UIBoardView Properties -
    @Environment(\.colorScheme) var colorScheme
    @Binding var board: GameBoard
    var isEditable: Bool = true
    var visibleGrid: Bool = true
    lazy var boardSize = CGSize(width: board.width,
                                height: board.height)
    private let gridColor: UIColor = .gray
    
    
    //MARK: - UIBoardView Inits -
    init(board: Binding<GameBoard>) {
        self._board = board
        super.init(frame: .zero)
        self.addGestureRecognizer(UITapGestureRecognizer(
                                    target: self,
                                    action: #selector(boardWasTapped(_:))))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - UIBoardView Methods -
    private func getCellOrigin(point: Point, cellSize: CGSize) -> CGPoint {
        CGPoint(x: CGFloat(point.x) * cellSize.width,
                y: CGFloat(point.y) * cellSize.height)
    }
    
    private func getCellSize(boardSize: CGSize, rect: CGRect) -> CGSize {
        CGSize(width: rect.width / boardSize.width,
               height: rect.height / boardSize.height)
    }
    
    
    //MARK: - UIBoardView Gesture Recognizers
    @objc private func boardWasTapped(_ gesture: UIGestureRecognizer) {
        guard isEditable else { return }
        let touch = gesture.location(in: self)
        let size = getCellSize(boardSize: boardSize,
                               rect: frame)
        let point = Point(
            x: Int(touch.x / size.width),
            y: Int(touch.y / size.height))
        let touchedRect = CGRect(
            origin: getCellOrigin(point: point,
                                  cellSize: size),
            size: size)
        
        board.toggleCell(at: point)
        setNeedsDisplay(touchedRect)
    }
    
    
    //MARK: - UIBoardView View Draw -
    override func draw(_ rect: CGRect) {
        let liveColor = UIColor { traits in
            switch traits.userInterfaceStyle {
            case .dark: return .white
            default: return .black
            }
        }
        let deadColor = UIColor { traits in
            switch traits.userInterfaceStyle {
            case .dark: return .black
            default: return .white
            }
        }
        let cellSize = getCellSize(boardSize: boardSize,
                                   rect: rect)
        
        deadColor.set()
        UIRectFill(rect)
        if visibleGrid {
            gridColor.setStroke()
        }
        
        for column in 0..<board.width {
            for row in 0..<board.height {
                let point = Point(x: column,
                                  y: row)
                guard let cell = board.cell(at: point) else { continue }
                let origin = getCellOrigin(point: point,
                                           cellSize: cellSize)
                let cellColor = cell.isAlive ? liveColor : deadColor
                
                if visibleGrid {
                    cellColor.setFill()
                } else {
                    cellColor.set()
                }
                let cellRect = CGRect(origin: origin,
                                      size: cellSize)
                UIRectFill(cellRect)
                UIRectFrame(cellRect)
            }
        }
    }
    
}


struct GameBoardView_Previews: PreviewProvider {
    static let gridSize = 25
    
    static var previews: some View {
        GameBoardView(
            board: Binding(
                get: { .random(width: gridSize, height: gridSize) },
                set: { _ in }),
            visibleGrid: Binding(get: { true }, set: { _ in }),
            isEditable: true)
            .previewDevice("iPhone XS")
            
    }
}
