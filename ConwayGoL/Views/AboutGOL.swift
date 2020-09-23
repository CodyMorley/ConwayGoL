//
//  AboutGOL.swift
//  ConwayGoL
//
//  Created by Bling Morley on 9/22/20.
//

import SwiftUI


fileprivate let rules = [
    "Cells (represented by a point on the grid) are either dead or alive.",
    "Each generation of cells is determined by the layout of the previous generation.",
    "If a live cell has < 2 neighbors, it dies (as if by isolation).",
    "If a live cell has > 3 neighbors, it dies (as if by overpopulation).",
    "If a dead cell has exactly 3 neighbors, it springs to life (as if by reproduction).",
    "From these simple rules, many complex organisms can come to life and evolve!"
]

fileprivate let algorithmText = """
The "Game of Life" is a famous example of a cellular automaton created by British mathematician John Conway in 1970.

The algorithm implemented here is a fairly crude one. A map is constructed of 'cell' enums (which can be dead or alive), which are iterated over using the rules above. The runtime complexity is than O(n * m) where n and m are the width and height respectively.

A very fast and more complex algorithm called "HashLife" is also possible that makes use of a QuadTree structure as well as a cache of next generations for cell arrangements.

SwiftUI was used for the UI. Performance could likely be improved with a lower-level UIKit implementation.
"""


struct AboutGOL: View {
    let title = "John Conway's Game of Life"
    
    var body: some View {
        ScrollView {
            rulesView()
            algorithmView()
        }
        .navigationBarTitle(Text("About"), displayMode: .large)
        .edgesIgnoringSafeArea([])
        .navigationBarHidden(false)
    }
    
    private func rulesView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rules")
                .font(.title)
                .fontWeight(.bold)
            VStack(alignment: .leading, spacing: 8) {
                ForEach(rules, id: \.self) { rule in
                    Text("• \(rule)")
                        .fontWeight(.medium)
                }
            }
        }
        .padding()
    }
    
    private func algorithmView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Algorithm")
                .font(.title)
                .fontWeight(.bold)
            Text(algorithmText)
        }.padding()
    }
}

struct AboutGOL_Previews: PreviewProvider {
    static var previews: some View {
        AboutGOL()
    }
}
