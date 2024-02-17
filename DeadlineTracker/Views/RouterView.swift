//
//  RouterView.swift
//  DeadlineTracker
//
//  Created by Anıl Öncül on 17.02.2024.
//

import SwiftUI

struct RouterView: View {
    var body: some View {
        TabView {
            // Tab 1
            FirstTabView()
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Tasks")
                }
            SecondTabView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Calendar")
                }
        }
    }
}

#Preview {
    RouterView()
}
