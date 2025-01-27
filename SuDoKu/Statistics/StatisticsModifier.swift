//
//  StatisticsModifier.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15\.02\.24\. 
//  Modified by Peter Eriksson 2025-01-26
//

import SwiftUI

struct StatisticsModifier: ViewModifier {
    @State private var statisticsSheetPresented = false
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        statisticsSheetPresented.toggle()
                    } label: {
                        Label("statistics", systemImage: "medal")
                            .labelStyle(.iconOnly)
                    }
                }
            }
            .sheet(isPresented: $statisticsSheetPresented) {
                StatisticsSheet()
            }
    }
}

#Preview {
    NavigationStack {
        Text(verbatim: ":)")
            .modifier(StatisticsModifier())
    }
}
