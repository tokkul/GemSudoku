//
//  GridView+Background.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 16.02.24.
//

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
                .stroke(lineWidth: 1)
                
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
                .stroke(lineWidth: 2)
            }
            .foregroundStyle(.accent)
        }
    }
}
