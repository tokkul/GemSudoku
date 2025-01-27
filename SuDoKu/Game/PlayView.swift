//
//  PlayView.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 17.02.24.
//

import SwiftUI
import Defaults

struct PlayView: View {
    @Default(.size) private var size
    @Default(.difficulty) private var difficulty
    
    @State var state: GameState = .loading
    
    var body: some View {
        NavigationStack {
            Group {
                switch state {
                    case .loading:
                        ProgressView()
                            .task {
                                state = .ongoing(game: Game.create(size: size, difficulty: difficulty))
                            }
                    case .ongoing(let game):
                        GameView(game: game) {
                            Task {
                                try? await Task.sleep(nanoseconds: 500_000_000)
                                state = .finished(valid: game.board.valid)
                            }
                        }
                        .modifier(DebugCompleteModifier(state: $state))
                    case .finished(let valid):
                        if valid {
                            SolvedView() { state = .loading }
                        } else {
                            FailedView() { state = .loading }
                        }
                }
            }
            .modifier(ToolbarModifier() { state = .loading })
            .modifier(StatisticsModifier())
        }
        .onChange(of: difficulty) { state = .loading }
    }
}

extension PlayView {
    struct ToolbarModifier: ViewModifier {
        @Default(.difficulty) private var difficulty
        
        let createGameCallback: () -> Void
        
        func body(content: Content) -> some View {
            content
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            createGameCallback()
                        } label: {
                            Label("retry", systemImage: "arrow.2.squarepath")
                                .labelStyle(.iconOnly)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            ForEach(Board.Difficulty.allCases, id: \.hashValue) { difficulty in
                                Button {
                                    self.difficulty = difficulty
                                } label: {
                                    Text(difficulty.name)
                                }
                            }
                        } label: {
                            Label("difficulty", systemImage: "command")
                                .labelStyle(.iconOnly)
                        }
                    }
                }
        }
    }
}

extension PlayView {
    enum GameState {
        case loading
        case ongoing(game: Game)
        case finished(valid: Bool)
    }
}

extension PlayView {
    struct DebugCompleteModifier: ViewModifier {
        @Default(.size) private var size
        
        @Binding var state: GameState
        
        func body(content: Content) -> some View {
            content
                #if DEBUG
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            let game = Game.init(board: .generate(size: size))
                            game.board.values[0] = nil
                            
                            state = .ongoing(game: game)
                        } label: {
                            Image(systemName: "bolt.fill")
                        }
                     }
                        
                    }
            
                #endif
        }
    }
}

#Preview {
    PlayView()
}
