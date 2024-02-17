//
//  SetupView.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 17.02.24.
//

import SwiftUI
import Defaults

struct SetupView: View {
    @Default(.setupComplete) var setupComplete
    
    @Default(.allowMistakes) var allowMistakes
    @Default(.suggestionStrength) var suggestionStrength
    
    @State private var setupSheetPresented = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("SuDoKu")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 100)
                .padding(.bottom, 25)
            
            Text("setup.name")
                .fontDesign(.rounded)
            
            Text("setup.text")
                .foregroundStyle(.secondary)
            
            Button {
                setupSheetPresented.toggle()
            } label: {
                Text("setup.continue")
            }
            .padding(.top)
            
            Spacer()
        }
        .sheet(isPresented: $setupSheetPresented) {
            NavigationStack {
                Form {
                    Section {
                        Toggle("setup.mistakes", isOn: $allowMistakes)
                    } footer: {
                        Text("setup.mistakes.text")
                    }
                    
                    Section {
                        Picker("setup.suggestions", selection: $suggestionStrength) {
                            ForEach(Board.SuggestionStrength.allCases, id: \.hashValue) { strength in
                                Text(strength.name)
                                    .tag(strength)
                            }
                        }
                    } footer: {
                        Text("setup.suggestions.text")
                    }
                    
                    Button {
                        setupSheetPresented = false
                    } label: {
                        HStack {
                            Spacer()
                            Text("setup.continue")
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .navigationTitle("setup.title")
                .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .onChange(of: setupSheetPresented) {
            if setupSheetPresented == false {
                setupComplete = true
            }
        }
    }
}

#Preview {
    SetupView()
}
