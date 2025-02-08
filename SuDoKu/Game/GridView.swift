//
//  GridView.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15\.02\.24\. 
//  Modified by Peter Eriksson 2025-01-26
//
//GridView Structure
//Properties:
//
//let game: Game: The game model.
//@Binding var selectedSpace: Int?: A binding to track the selected space.
//@Binding var animation: GameView.GameAnimation: A binding to control animations.
//@Binding var displayMode: DisplayMode: A binding to control the display mode.
//Body:
//
//Uses GeometryReader to get the size of the available space.
//Calculates the size of each cell based on the width of the view and the length of the game board.
//Uses a ZStack to layer different components:
//Rectangle: Background of the grid.
//SelectBackground: Highlights the selected space.
//Divider: Draws the grid lines.
//Grid: Displays the actual game grid.
//Styling:
//
//Adds a border and corner radius to the grid.
//Maintains a 1:1 aspect ratio for the grid.
//Grid Structure (Nested in GridView)
//Properties:
//
//@Default(.allowMistakes) private var allowMistakes: A custom property wrapper for user settings.
//let game: Game: The game model.
//let size: CGFloat: The size of each cell.
//@Binding var selectedSpace: Int?: A binding to track the selected space.
//@Binding var animation: GameView.GameAnimation: A binding to control animations.
//@Binding var displayMode: DisplayMode: A binding to control the display mode.
//Body:
//
//Uses nested VStack and HStack to create the grid layout.
//Iterates over the rows and columns of the game board using ForEach.
//Calculates the index of each cell and determines if it should be animated based on the current animation state.
//Uses Button to handle cell selection:
//If the cell is empty or mistakes are allowed, it updates the selectedSpace state with animation.
//Triggers haptic feedback on selection.
//Cell Content:
//
//If the cell has a number, it displays an AnimatedImageView.
//If the cell is selected, it shows a gray rectangle.
//Otherwise, it shows a clear color.
//Haptic Feedback:
//
//Defines a private function triggerHapticFeedback to provide haptic feedback when a cell is selected.

import SwiftUI
import Defaults
import UIKit

//setup the square board

struct GridView: View {
    let game: Game
    
    @Binding var selectedSpace: Int?
    @Binding var animation: GameView.GameAnimation
   @Binding var displayMode: DisplayMode

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let size = width / CGFloat(game.board.length)
            
            ZStack {
                Rectangle()
//                    .foregroundStyle(.background.secondary)
                   .foregroundStyle(.blue.opacity(0.3))
                
                SelectBackground(game: game, size: size, selectedSpace: $selectedSpace)
                Divider(game: game, width: width)
                Grid(game: game, size: size, selectedSpace: $selectedSpace, animation: $animation, displayMode: $displayMode )
            }
            .border(.accent, width: 4)
            .cornerRadius(20)
        }
        .aspectRatio(1, contentMode: .fit)
     }
    
}

extension GridView {
    struct Grid: View {
        @Default(.allowMistakes) private var allowMistakes
        
        let game: Game
        let size: CGFloat
        @Binding var selectedSpace: Int?
        @Binding var animation: GameView.GameAnimation
        @Binding var displayMode: DisplayMode
        
        var body: some View {
                 
                VStack(spacing: 0) {
                    ForEach(0..<game.board.length, id: \.hashValue) { i in
                        HStack(spacing: 0) {
                            ForEach(0..<game.board.length, id: \.hashValue) { j in
                                let index = i * game.board.length + j
                                let animate: Bool = {
                                    if animation == .all {
                                        return true
                                    } else if case let .row(row) = animation {
                                        return index / game.board.length == row
                                    } else if case let .column(column) = animation {
                                        return index % game.board.length == column
                                    } else if case let .square(x, y) = animation {
                                        let currentSquareX = (index % game.board.length) / game.board.side
                                        let currentSquareY = (index / game.board.length) / game.board.side
                                        
                                        return currentSquareX == x && currentSquareY == y
                                    }
                                    
                                    return false
                                }()
                                
                                Button {
                                    if game.board.values[index] == nil || allowMistakes {
                                        withAnimation(.spring) {
                                            if selectedSpace == index {
                                                selectedSpace = nil
                                            } else {
                                                selectedSpace = index
                                            }
                                        }
                                        triggerHapticFeedback()
                                    }
                                } label: {
                                    if let number = game.board.values[index] {
                                        AnimatedImageView(number: number, index: index, animate: animate, game: game, displayMode: $displayMode)
                                
                                    } else if selectedSpace == index {
                                        Rectangle()
                                            .foregroundStyle(.gray.opacity(0.9))
                                    } else {
                                        Color.clear
                                    }
                                }
                                .frame(width: size, height: size)
                            }
                            
                        }
                    }
                }
            
            }
        // Function to trigger haptic feedback
                private func triggerHapticFeedback() {
                    let generator = UIImpactFeedbackGenerator(style:.soft)
                    generator.impactOccurred()
                }
 
        }
    }

