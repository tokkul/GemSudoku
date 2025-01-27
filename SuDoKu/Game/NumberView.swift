//
//  NumberView.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15\.02\.24\. 
//  Modified by Peter Eriksson 2025-01-26
//

import SwiftUI
import Defaults

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
        LazyVGrid(columns: .init(repeating: .init(.flexible()), count: game.board.length)) {
            ForEach(1...game.board.length, id: \.hashValue) { number in
//                let suggested = suggestions.contains(number)
                
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
//                    Text(String(number))
//                        .font(.title)
//                        .fontDesign(.rounded)
//                        .foregroundStyle(disabled ? .red.opacity(0.75) : suggested ? .accent : .primary)
                }
            }
        }
        .disabled(disabled)
    }
}
