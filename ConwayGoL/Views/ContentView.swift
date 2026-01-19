//
//  ContentView.swift
//  ConwayGoL
//
//  Created by Cody Morley on 9/22/20.
//

import SwiftUI


struct ContentView: View {
    //MARK: - Properties -
    /// These properties define the various visual elements and paramenters of the user interface.
    @ObservedObject private var gameEngine = GameEngine()
    @State private var visiblePopSetup = false
    @State private var visibleAbout = false
    @State private var visibleBoardSetup = false
    @State private var visibleGrid = false
    
    ///this will keep our framerate formatter from dividing down futher than hundredths of a second/frame.
    private let framerateFormatter = configure(NumberFormatter()) { $0.maximumFractionDigits = 2 }
    private let topBlue = Color(UIColor(light: UIColor(red: 0.87,
                                                       green: 0.93,
                                                       blue: 1,
                                                       alpha: 1),
                                        dark: UIColor(red: 0.08,
                                                      green: 0.12,
                                                      blue: 0.2,
                                                      alpha: 1),
                                        defaultsToLight: false))
    private let bottomBlue = Color(UIColor(light: UIColor(red: 0.5,
                                                          green: 0.6,
                                                          blue: 0.7,
                                                          alpha: 1),
                                           dark: UIColor(red: 0.25,
                                                         green: 0.3,
                                                         blue: 0.5,
                                                         alpha: 1),
                                           defaultsToLight: false))
    private let themeGrayscale = Color(UIColor(light: .white,
                                               dark: .black,
                                               defaultsToLight: false))
    private let controlsHeaderBackground = Color(UIColor(light: UIColor(red: 1,
                                                                        green: 0.96,
                                                                        blue: 0.89,
                                                                        alpha: 1),
                                                         dark: UIColor(red: 0.17,
                                                                       green: 0.18,
                                                                       blue: 0.11,
                                                                       alpha: 1),
                                                         defaultsToLight: false))
    private let controlsBackgroundColor = Color(UIColor(light: UIColor(red: 1,
                                                                       green: 0.97,
                                                                       blue: 1,
                                                                       alpha: 1),
                                                        dark: UIColor(red: 0.14,
                                                                      green: 0.03,
                                                                      blue: 0.08,
                                                                      alpha: 1),
                                                        defaultsToLight: false))
    ///Color - Definitions for the various UIColors used in the UIKit methods and Colors used in the SwiftUI methods.
    private var defaultButtonBG: Color {
        Color(red: 0.5,
              green: 0.9,
              blue: 0.8,
              opacity: 0.5)
    }
    
    
    //MARK: - Inits -
    init() {
        configure(UITableView.appearance()) {
            $0.backgroundColor = .clear
            $0.tableHeaderView?.backgroundColor = .green
            $0.tableFooterView = UIView()
        }
    }
    
    
    //MARK: - Body -
    ///Declares the main user interface of the application.
    /// Nav View --holds--> (ZStack--holds--> (VStack--holds-->(GameBoardView, ControlViews,) Modal Presentations))
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        topBlue,
                        bottomBlue,
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 16) {
                    
                    GameBoardView(board: self.$gameEngine.board,
                                  visibleGrid: self.$visibleGrid,
                                  isEditable: !self.gameEngine.isRunning)
                    .border(Color.gray)
                    .shadow(color: Color(white: 1,
                                         opacity: 0.1),
                            radius: 5,
                            x: -5,
                            y: -5)
                    .shadow(color: Color(white: 0,
                                         opacity: 0.3),
                            radius: 6,
                            x: 7,
                            y: 7)
                    .padding(.horizontal, 8)
                    .padding(.top, 12)
                    
                    List {
                        Section(
                            header: HStack {
                                Spacer()
                                Text("Controls".uppercased())
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            .padding(.vertical, 6)
                            .frame(alignment: .center)
                            .background(controlsHeaderBackground)
                            .listRowInsets(
                                EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                            )
                            .cornerRadius(10)
                        ) {
                            progressionControls()
                            populationViews()
                            sizeViews()
                            framerateControls()
                        }
                        .listStyle(GroupedListStyle())
                        .listRowBackground(controlsBackgroundColor)
                    }
                    .buttonStyle(LifeButtonStyle())
                }
                .navigationBarTitle("Game of Life", displayMode: .inline)
                .navigationBarItems(
                    trailing: Button(action: {
                        self.visibleAbout = true
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.white)
                            .padding(8)
                    }
                        .background(Circle().foregroundColor(bottomBlue))
                        .shadow(color: bottomBlue.opacity(0.5),
                                radius: 6,
                                x: 4,
                                y: 4)
                        .shadow(color: themeGrayscale.opacity(0.8),
                                radius: 6,
                                x: 4,
                                y: 4))
                .sheet(isPresented: $visibleAbout,
                       content: AboutGOL.init)
            }
        }
    }
    
    //MARK: - Subviews -
    ///These methods control various elements of the display based on user input or states.
    private func framerateControls() -> some View {
        Group {
            HStack(spacing: 8) {
                Slider(
                    value: $gameEngine.requestedFramerate,
                    in: gameEngine.framerateRange)
                Text(framerateString(from: gameEngine.requestedFramerate) + " gens/sec")
            }.padding(.horizontal, 20)
            
            if gameEngine.isRunning {
                HStack(alignment: .center) {
                    Spacer()
                    framerateIndicator()
                    Spacer()
                }
            }
        }
    }
    
    private func framerateIndicator() -> some View {
        Group {
            if gameEngine.isRunning {
                Text(framerateString(from: gameEngine.actualFrameRate) + "gens/sec")
            }
        }
    }
    
    private func progressionControls() -> some View {
        HStack(alignment: .center, spacing: 20) {
            Spacer()
            
            Button(action: gameEngine.toggleRunning) {
                HStack(spacing: 4) {
                    if gameEngine.isRunning {
                        Text("Pause")
                        Image(systemName: "pause.fill")
                    } else {
                        Text("Start")
                        Image(systemName: "play.fill")
                    }
                }
            }
            
            Button(action: gameEngine.advanceGeneration) {
                HStack(spacing: 2) {
                    Text("Step")
                    Image(systemName: "goforward")
                }
                .disabled(gameEngine.isRunning)
            }
            
            Spacer()
        }
    }
    
    private func populationViews() -> some View {
        Group {
            Button(action: { self.visiblePopSetup.toggle() }) {
                HStack(alignment: .center) {
                    Spacer()
                    
                    Text("Population:")
                        .font(.caption)
                    
                    Text(String(gameEngine.board.pop))
                        .font(.headline)
                    
                    Spacer()
                    
                    Divider()
                    
                    Spacer()
                    
                    Text("Generation:")
                        .font(.caption)
                    
                    Text(String(gameEngine.generation))
                        .font(.headline)
                    
                    Spacer()
                    
                    indicator(for: visiblePopSetup)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            
            if visiblePopSetup { PopulationControls(gameEngine: gameEngine) }
        }
    }
    
    private func sizeViews() -> some View {
        Group {
            Button(action: { self.visibleBoardSetup.toggle() }) {
                HStack(alignment: .center) {
                    Spacer()
                    
                    Text("Current size:")
                    
                    Text("\(gameEngine.board.width)x\(gameEngine.board.height)")
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    indicator(for: visibleBoardSetup)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if visibleBoardSetup { SizeSetupView(gameEngine: gameEngine, visibleGrid: $visibleGrid) }
        }
    }
    
    private func indicator(for showing: Bool) -> some View {
        Group {
            if showing {
                Image(systemName: "chevron.up")
            } else {
                Image(systemName: "chevron.down")
            }
        }
        .foregroundColor(.secondary)
    }
    
    //MARK: - Helpers -
    ///Changes our current framerate to a string output for convenience.
    private func framerateString(from value: Double) -> String {
        framerateFormatter.string(from: NSNumber(value: value)) ?? "??"
    }
}

//MARK: - Previews -
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice(.init(stringLiteral: "iPhone XS"))
    }
}

struct DarkContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone XS")
            .transformEnvironment(\.colorScheme) { uiStyle in
                uiStyle = .dark
            }
    }
}





