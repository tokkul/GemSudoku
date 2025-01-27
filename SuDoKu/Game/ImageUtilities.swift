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

func imageName(for number: Int) -> String {
    switch number {
    case 1: return "red"
    case 2: return "orange"
    case 3: return "yellow"
    case 4: return "lightGreen"
    case 5: return "green"
    case 6: return "lightBlue"
    case 7: return "blue"
    case 8: return "pink"
    case 9: return "purple"
    default: return "clear"
    }
}

func imageColor(for number: Int) -> Color {
    switch number {
    case 1: return .red
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
