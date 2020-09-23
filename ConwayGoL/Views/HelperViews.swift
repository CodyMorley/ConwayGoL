//
//  HelperViews.swift
//  ConwayGoL
//
//  Created by Cody Morley on 9/23/20.
//

import SwiftUI

//MARK: - Color Header -
struct ColorHeader<NameView: View>: View {
    let nameView: NameView
    let color: Color
    
    init(color: Color, @ViewBuilder nameView: () -> NameView) {
        self.nameView = nameView()
        self.color = color
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                nameView
                Spacer()
            }
            Spacer()
        }.padding(.all, 0)
        .background(FillAll(color: color))
    }
}

extension ColorHeader where NameView == Text {
    init(name: String, color: Color) {
        self.init(color: color) {
            Text(name)
        }
    }
}


//MARK: - Fill All -
struct FillAll: View {
    let color: Color
    
    var body: some View {
        GeometryReader { proxy in
            self.color.frame(width: proxy.size.width * 1.3).fixedSize()
        }
    }
}


//MARK: - Button Style -
struct LifeButtonStyle: ButtonStyle {
    private var bg: Color
    
    init(bg: Color? = nil) {
        self.bg = bg ?? Color(red: 0.75,
                              green: 0.82,
                              blue: 0.95)
    }
    
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        configuration.label
            .foregroundColor(.black)
            .padding(4)
            .background(bg)
            .cornerRadius(8)
            .shadow(radius: 2)
    }
}


