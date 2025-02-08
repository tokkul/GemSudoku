//
//  NumberView.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15\.02\.24\. 
//  Modified by Peter Eriksson 2025-01-26
//

import SwiftUI
import Defaults

//    Overview
//    This SwiftUI view creates a grid of buttons using LazyVGrid. Each button represents a number and allows user interaction to input that number into a game board.
//
//    Key Components
//    disabled Variable:
//
//    This variable checks if selectedSpace is nil. If it is, the grid will be disabled.
//    LazyVGrid:
//
//    Creates a grid layout with flexible columns. The number of columns is equal to the length of the game board.
//    ForEach Loop:
//
//    Iterates over the range from 1 to the length of the game board, creating a button for each number.
//    Button Action:
//
//    When a button is pressed, it attempts to input the number into the game at the selectedSpace index.
//    If the input is unsuccessful, it triggers a shake animation.
//    If the input is successful, it clears the selectedSpace and triggers an animation.
//    Button Label:
//
//    The label of the button is an AnimatedImageView that displays the number and other game-related animations.
//    Detailed Breakdown
//    LazyVGrid:
//
//    columns: .init(repeating: .init(.flexible()), count: game.board.length): Creates a grid with a number of flexible columns equal to the length of the game board.
//    ForEach Loop:
//
//    ForEach(1...game.board.length, id: \.hashValue) { number in ... }: Iterates over the numbers from 1 to the length of the game board.
//    Button Action:
//
//    let result = game.input(number: number, index: selectedSpace!): Attempts to input the number into the game at the selectedSpace index.
//    if !result.success { ... }: If the input is unsuccessful, it triggers a shake animation.
//    else { ... }: If the input is successful, it clears the selectedSpace and triggers an animation.
//    Button Label:
//
//    AnimatedImageView(number: number, index: index, animate: animate, game: game, displayMode: $displayMode): Displays the number and other game-related animations.
//    Summary
//    This code creates a grid of buttons that allows users to input numbers into a game board. It handles user interactions, including successful and unsuccessful inputs, and provides visual feedback through animations.

struct NumberView: View {
    @Default(.suggestionStrength) var suggestionStrength
//    @State private var displayMode: DisplayMode = .image
    let game: Game
    
    
    @Binding var shake: Bool
    @Binding var selectedSpace: Int?
    @Binding var animation: GameView.GameAnimation
    @Binding var displayMode: DisplayMode
    let index = 0
    let animate = true

    var suggestions: [Int] {
        guard let selectedSpace = selectedSpace else { return [] }
        return game.board.suggestions(index: selectedSpace, strength: suggestionStrength)
    }
    
    var body: some View {
                let disabled = selectedSpace == nil
                let columns = Array(repeating: GridItem(.flexible()), count: game.board.length)
  
                LazyVGrid(columns: columns) {
                    ForEach(1...game.board.length, id: \.hashValue) { number in
                        Button {
                            let result = game.input(number: number, index: selectedSpace!)
                            
                            if !result.success {
                                shake = true
                                
                                withAnimation(.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
                                    shake = false
                                }
                            } else {
                                withAnimation(.spring) {
                                    selectedSpace = nil
                                    animation = result.animation
                                } completion: {
                                    animation = .none
                                }
                            }
                        } label: {
                            AnimatedImageView(number: number, index: index, animate: animate, game: game, displayMode: $displayMode)
                                .aspectRatio(1, contentMode: .fit) // Maintain aspect ratio
                        }
                    }
                }
                 .disabled(disabled)
                 .padding()
//                .aspectRatio(1, contentMode: .fit)
  }
    
    }
