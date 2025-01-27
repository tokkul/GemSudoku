//
//  StatisticsSheet.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15\.02\.24\. 
//  Modified by Peter Eriksson 2025-01-26
//

import SwiftUI
import Defaults

struct StatisticsSheet: View {
    @Default(.clues) private var clues
    @Default(.attempts) private var attempts
    
    @Default(.easySolved) private var easySolved
    @Default(.mediumSolved) private var mediumSolved
    @Default(.hardSolved) private var hardSolved
    @Default(.extremeSolved) private var extremeSolved
    
    @Default(.correct) private var correct
    @Default(.mistakes) private var mistakes
    
    var body: some View {
        NavigationStack {
            List {
                Text("attempts \(attempts)")
                Text("clues \(clues)")
                
                Section {
                    Text("easySolved \(easySolved)")
                    Text("mediumSolved \(mediumSolved)")
                    Text("hardSolved \(hardSolved)")
                    Text("extremeSolved \(extremeSolved)")
                }
                
                Section {
                    Text("correct \(correct)")
                    Text("mistakes \(mistakes)")
                }
                
                Section {
//                    Button {
//                        UIApplication.shared.open(URL(string: "https://github.com/rasmuslos/SuDoKu")!)
//                    } label: {
//                        Text("statistics.github")
//                    }
                    
                    Button {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    } label: {
                        Text("statistics.settings")
                    }
                    
                    Button {
                        _clues.reset()
                        _attempts.reset()
                        
                        _easySolved.reset()
                        _mediumSolved.reset()
                        _hardSolved.reset()
                        _extremeSolved.reset()
                        
                        _correct.reset()
                        _mistakes.reset()
                    } label: {
                        Text("statistics.reset")
                    }
                }
                
                Section {
                    
                } footer: {
                    HStack {
                        Spacer()
                        Text("developedBy")
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }
            }
            .navigationTitle("statistics.title")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    Text(verbatim: ":)")
        .sheet(isPresented: .constant(true)) {
            StatisticsSheet()
        }
}
