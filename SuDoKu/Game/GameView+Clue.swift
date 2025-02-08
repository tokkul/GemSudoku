//
//  GameView+Clue.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 16.02.24.
//

import SwiftUI
import Defaults

extension GameView {
    struct ClueView: View {
        @Default(.allowMistakes) private var allowMistakes
        
        let game: Game
        
        @Binding var blockUI: Bool
        @Binding var selectedSpace: Int?
//        @Binding var displayMode: DisplayMode
        
        var body: some View {
            VStack {
                
                if !game.eligibleForStatistics {
                    Text("statistics.ineligible")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                        .padding(.bottom, 10)
                }
                
                // Toggle button to switch between display modes
//                              Button(action: {
//                                  displayMode = (displayMode == .image) ? .color : .image
//                              }) {
//                                  Text("gem")
//                              }
//                              .padding()
//                              .sensoryFeedback(.increase, trigger: displayMode)

                
                Button {
                    let clue = game.clue()
                    
                    Task {
                        blockUI = true
                        
                        withAnimation {
                            selectedSpace = clue.1
                        }
                        
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        
                        withAnimation {
                            let _ = game.input(number: clue.0, index: clue.1)
                        }
                        
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        
                        withAnimation {
                            selectedSpace = nil
                        }
                        
                        blockUI = false
                    }
                } label: {
                    if allowMistakes {
                        Text("clue.disabled")
                    } else {
                        Label("clue", systemImage: "questionmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
                .disabled(allowMistakes)
            }
        }
    }
}
