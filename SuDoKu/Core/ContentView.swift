//
//  ContentView.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15\.02\.24\. 
//  Modified by Peter Eriksson 2025-01-26
//

import SwiftUI
import Defaults

struct ContentView: View {
    @Default(.setupComplete) var setupComplete
    
    var body: some View {
        if setupComplete {
            PlayView()
        } else {
            SetupView()
        }
    }
}

#Preview {
    ContentView()
}
