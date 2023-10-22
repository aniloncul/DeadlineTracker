//
//  ContentView.swift
//  DeadlineTracker
//
//  Created by Anıl Öncül on 20.10.2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State var showLanguageListView: Bool = false
    
    

    var body: some View {
        NavigationView {
            
            List {
                ForEach(items) { item in
                    let currentTimeInterval = Date().timeIntervalSinceReferenceDate
                    let timeInterval = item.deadlineDate.timeIntervalSinceReferenceDate
                    let timeRemaining = max(timeInterval - currentTimeInterval, 0)
                    let maxTimeInterval = item.deadlineDate.timeIntervalSince(item.timestamp)
                    let totalSeconds = Double(maxTimeInterval)
                    
                    
                    
                
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                        
//                    }
                    DeadlineListCell(title: item.deadlineName, deadlineTime: "\(item.deadlineDate)", timeIntervalDouble: timeRemaining, maxTimeInterval: totalSeconds)
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {showLanguageListView = true}) {
                        Label("Add Item", systemImage: "book")
                    }
                
                    
                }
            }
        }
        .sheet(isPresented: $showLanguageListView, content: {
            AddDeadlineSheetView()
        })
        
    }
    
    private func openAddSheetView() {
        
        withAnimation {
            let newItem = Item(timestamp: Date(), deadlineName: String(), deadlineDate: Date())
            modelContext.insert(newItem)
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date(), deadlineName: String(), deadlineDate: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
