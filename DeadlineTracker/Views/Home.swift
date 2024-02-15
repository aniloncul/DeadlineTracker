//
//  Home.swift
//  DeadlineTracker
//
//  Created by Anıl Öncül on 14.02.2024.
//

import SwiftUI
import SwiftData

struct Home: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State var showLanguageListView: Bool = false
    
    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            HeaderView()
            
        })
        .vSpacing(.top)
        
        
        
    }
       
    
    @ViewBuilder func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5) {
                Text(currentDate.format("MMMM"))
                    .foregroundStyle(.purple)
                
                Text(currentDate.format("YYYY"))
                    .foregroundStyle(.purple)
            }
            .font(.title.bold())
            
            Text(currentDate.formatted(date: .complete, time: .omitted))
                .font(.callout)
                .fontWeight(.semibold)
                .textScale(.secondary)
                .foregroundStyle(.gray)
        }
                .padding(15)
                .hSpacing(.leading)
                .background(.ultraThinMaterial)
    }
    
    
}



#Preview {
    Home()
}

