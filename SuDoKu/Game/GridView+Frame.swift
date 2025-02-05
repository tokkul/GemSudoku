//
//  GridView+Background.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 16.02.24.
//
//SelectBackground View
//This view highlights the selected row, column, and 3x3 square in a grid.
//
//Properties:
//
//game: An instance of the Game model.
//size: The size of each grid cell.
//selectedSpace: A binding to the currently selected space in the grid.
//Body:
//
//A VStack containing rows of the grid.
//If selectedSpace is not nil, it iterates over the rows and columns of the grid.
//For each cell, it calculates whether the cell is in the same row, column, or 3x3 square as the selected space.
//It then displays a Rectangle with a gray background if the cell is in the same row, column, or 3x3 square as the selected space, otherwise it is clear.
//Divider View
//This view draws grid lines to visually separate the cells in the grid.
//
//Properties:
//
//game: An instance of the Game model.
//width: The total width of the grid.
//Body:
//
//A Group containing two Path elements.
//The first Path draws thin lines (1 point) between the cells, except at the boundaries of the 3x3 squares.
//The second Path draws thicker lines (2 points) at the boundaries of the 3x3 squares.
//Both paths use the stroke modifier to set the line width and the foregroundStyle modifier to set the color.
//Summary
//The SelectBackground view highlights the selected row, column, and 3x3 square in the grid.
//The Divider view draws the grid lines, with thicker lines at the boundaries of the 3x3 squares.

import SwiftUI

extension GridView {
    struct SelectBackground: View {
        let game: Game
        let size: CGFloat
        
        @Binding var selectedSpace: Int?
        
        var body: some View {
            VStack(spacing: 0) {
                if let selectedSpace = selectedSpace {
                    ForEach(0..<game.board.length, id: \.hashValue) { i in
                        let row = selectedSpace / game.board.length
                        let rowActive = row == i
                        
                        HStack(spacing: 0) {
                            ForEach(0..<game.board.length, id: \.hashValue) { j in
                                let column = selectedSpace % game.board.length
                                let columnActive = column == j
                                
                                let index = i * game.board.length + j
                                let currentSquareX = (index % game.board.length) / game.board.side
                                let currentSquareY = (index / game.board.length) / game.board.side
                                let selectedSquareX = column / game.board.side
                                let selectedSquareY = row / game.board.side
                                let squareActive = currentSquareX == selectedSquareX && currentSquareY == selectedSquareY
                                
                                Rectangle()
                                    .foregroundStyle(rowActive || columnActive || squareActive ? .gray.opacity(0.25) : .clear)
                                    .frame(width: size, height: size)
                            }
                        }
                    }
                }
            }
        }
    }
    
    struct Divider: View {
        let game: Game
        let width: CGFloat
        
        var body: some View {
            Group {
                Path { path in
                    for i in 1...game.board.length {
                        if i % game.board.side == 0 {
                            continue
                        }
                        
                        let offset = width / CGFloat(game.board.length) * CGFloat(i)
                        
                        path.move(to: .init(x: offset, y: 0))
                        path.addLine(to: .init(x: offset, y: width))
                        
                        path.move(to: .init(x: 0, y: offset))
                        path.addLine(to: .init(x: width, y: offset))
                    }
                }
                .stroke(lineWidth: 0)
                
                Path { path in
                    for i in 1...game.board.length {
                        if i % game.board.side != 0 || i == game.board.length {
                            continue
                        }
                        
                        let offset = width / CGFloat(game.board.length) * CGFloat(i)
                        
                        path.move(to: .init(x: offset, y: 0))
                        path.addLine(to: .init(x: offset, y: width))
                        
                        path.move(to: .init(x: 0, y: offset))
                        path.addLine(to: .init(x: width, y: offset))
                    }
                }
                .stroke(lineWidth: 4)
            }
            .foregroundStyle(.accent)
        }
    }
}
