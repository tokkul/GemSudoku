//
//  ImageUtilities.swift
//  GemSudoku
//
//  Created by Peter Eriksson on 2025-01-26.
//

import SwiftUI

enum DisplayMode {
    case image
    case color
}

struct AnimatedImageView: View {
    let number: Int
    let index: Int
    let animate: Bool
    let game: Game
    @Binding var displayMode: DisplayMode
    
    var body: some View {
        let delay = (Double(index) / Double(game.board.length * game.board.length)) * 0.5
        let springAnimation = Animation.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)
        let animation = springAnimation.delay(delay)

        Group {
            if displayMode == .image {
                Image(imageName(for: number))
                    .resizable()
            } else {
                Circle()
                    .fill(imageColor(for: number))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding(1)
        .scaleEffect(animate ? 1.5 : 1)
        .animation(animation, value: animate)
    }
}

func imageName(for number: Int) -> String {
    switch number {
    case 1: return "red"
    case 2: return "orange"
    case 3: return "yellow"
    case 4: return "lgreen"
    case 5: return "green"
    case 6: return "lblue"
    case 7: return "blue"
    case 8: return "pink"
    case 9: return "purple"
    default: return "clear"
    }
}

func imageColor(for number: Int) -> Color {
    switch number {
    case 1: return .xRed
    case 2: return .xOrange
    case 3: return .xYellow
    case 4: return .xLGreen
    case 5: return .xGreen
    case 6: return .xLBlue
    case 7: return .xBlue
    case 8: return .xPink
    case 9: return .xPurple
    default: return .clear
    }
}
