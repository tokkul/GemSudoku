//
//  GameView.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15\.02\.24\. 
//  Modified by Peter Eriksson 2025-01-26
//
//Properties:
//
//@Default(.allowMistakes) and @Default(.difficulty): These are custom property wrappers for user settings.
//@Binding var displayMode: DisplayMode: A binding to control the display mode.
//let game: Game: The game model.
//let completedCallback: () -> Void: A callback function to be called when the game is completed.
//@State private var animation: GameAnimation = .none: State to control animations.
//@State private var shake = false: State to control shaking animation.
//@State private var blockUI = false: State to block UI interactions.
//@State private var selectedSpace: Int?: State to track the selected space.
//Computed Property:
//
//selectedSpaceProxy: A binding proxy for selectedSpace that prevents changes when blockUI is true.
//Body:
//
//The main view layout is defined using VStack and HStack.
//Displays game statistics like correct answers, mistakes, and completion percentage.
//Contains NumberView and GridView for displaying the game board and numbers.
//ClueView for displaying clues.
//Uses .padding(), .environment(game), .navigationTitle("sudoku.title"), and .sensoryFeedback(.success, trigger: animation) for styling and behavior.
//Animation Handling:
//
//onChange(of: game.board.solved): Triggers animations and the completion callback when the game is solved.
//GameAnimation Enum:
//
//Defines different types of animations (none, all, row, column, square).
//Previews:
//
//GameView_Previews and GameView_Previews_Small provide previews for different game sizes.


import SwiftUI
import Defaults

struct GameView: View {
    @Default(.allowMistakes) private var allowMistakes
    @Default(.difficulty) private var difficulty
//    @State private var displayMode: DisplayMode = .image
    
    let game: Game
  @Binding var displayMode: DisplayMode // Add displayMode binding
    let completedCallback: () -> Void
    
    @State private var animation: GameAnimation = .none
    
    @State private var shake = false
    @State private var blockUI = false
    @State private var selectedSpace: Int?
    
    
    
    private var selectedSpaceProxy: Binding<Int?> {
        .init(get: { selectedSpace }, set: {
            if blockUI { return }
            selectedSpace = $0
        })
    }
    
    var body: some View {
        VStack {
            HStack {
                if !allowMistakes {
                    Text("\(game.correct) correct")
                }
                
                Spacer()
                
                Text(String(String(game.board.solved * 100).prefix(2)))
                + Text(verbatim: "% - ")
                + Text(difficulty.name)
                
                Spacer()
                
                if !allowMistakes {
                    Text("\(game.mistakes) mistakes")
                }
            }
            .font(.caption.smallCaps())
            .foregroundStyle(.secondary)

            VStack {
                
            NumberView(game: game, shake: $shake, selectedSpace: selectedSpaceProxy, animation: $animation, displayMode: $displayMode)
                .padding(.bottom, 40)
               .frame(maxWidth: .infinity) // Make NumberView take up full width
 
            GridView(game: game, selectedSpace: selectedSpaceProxy, animation: $animation, displayMode: $displayMode)
                .offset(x: shake ? 30 : 0)
                .frame(maxWidth: .infinity) // Make NumberView take up full width
            NumberView(game: game, shake: $shake, selectedSpace: selectedSpaceProxy, animation: $animation, displayMode: $displayMode)
                .padding(.top, 40)
               .frame(maxWidth: .infinity) // Make NumberView take up full width
                }

                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Frame for NumberView and GridView
//                        .border(Color.gray, width: 2) // Optional: Add a border to the frame
            Spacer()
            
            ClueView(game: game, blockUI: $blockUI, selectedSpace: $selectedSpace)
        }
        .padding()
        .environment(game)
        .navigationTitle("sudoku.title")
        .navigationBarTitleDisplayMode(.inline)
        .sensoryFeedback(.success, trigger: animation)
        .onChange(of: game.board.solved) {
            if game.board.solved >= 1 {
                withAnimation {
                    blockUI = true
                    animation = .all
                } completion: {
                    animation = .none
                    completedCallback()
                }
            }
        }
    }
}

extension GameView {
    enum GameAnimation: Equatable {
        case none
        case all
        case row(row: Int)
        case column(column: Int)
        case square(x: Int, y: Int)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State private var displayMode: DisplayMode = .image // Define displayMode state

        var body: some View {
            NavigationStack {
                GameView(game: .create(size: .NineXNine, difficulty: .xmedium), displayMode: $displayMode) {
                    print("Completed")
                }
            }
        }
    }
}

struct GameView_Previews_Small: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State private var displayMode: DisplayMode = .image // Define displayMode state

        var body: some View {
            NavigationStack {
                GameView(game: .create(size: .FourXFour, difficulty: .xmedium), displayMode: $displayMode) {
                    print("Completed")
                }
            }
        }
    }
}
//
//#Preview {
//    @State private var displayMode: DisplayMode = .image // Define displayMode state
//    NavigationStack {
//        GameView(game: .create(size: .NineXNine, difficulty: .medium), displayMode: $displayMode) {
//            print("Completed")
//        }
//    }
//}
//
//#Preview {
//    @State private var displayMode: DisplayMode = .image // Define displayMode state
//    NavigationStack {
//        GameView(game: .create(size: .FourXFour, difficulty: .medium), displayMode: $displayMode) {
//            print("Completed")
//        }
//    }
//}
