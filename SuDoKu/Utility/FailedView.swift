//
//  FailedView.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 16.02.24.
//

import SwiftUI
import Defaults

struct FailedView: View {
    let playAgainCallback: () -> Void
    
    var body: some View {
        VStack {
            ContentUnavailableView("failed.title", systemImage: "xmark.circle", description: Text("failed.text"))
            
            Button {
                playAgainCallback()
            } label: {
                Text("failed.prompt")
            }
        }
    }
}

#Preview {
    FailedView() {
        print("Play again")
    }
}
