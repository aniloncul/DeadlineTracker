//
//  AddDeadlineSheetView.swift
//  DeadlineTracker
//
//  Created by Anıl Öncül on 20.10.2023.
//

import SwiftUI
import SwiftData

struct AddDeadlineSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @Environment(\.dismiss) var dismiss
    
    @State var deadline: String = ""
    @State var deadlineDate = Date()
    
    private let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let minRange = calendar.date(byAdding: .minute, value: +1, to: Date())!
        let maxRange = calendar.date(byAdding: .year, value: 10, to:Date())!
        
        let timeRange = minRange...maxRange
        return timeRange
    }()
    
    var body: some View {
        VStack{
            
            Text("Enter your Deadline")
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
            TextField("Enter your deadline",
                      text: $deadline
            )
            .border(Color.black)
            .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
            
            .font(.title)
            
            DatePicker(
            "Select Deadline",
            selection: $deadlineDate,
            in: dateRange,
            displayedComponents: [.date, .hourAndMinute]
            ).datePickerStyle(.compact)
            
            
            Button(action: {
                addItem()
                dismiss()
            }) {
                Text("Save")
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
            }
            .padding(30)
            
        }
        .border(Color.red)
        .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
        Text(deadline)
        
        
    }

    
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date(), deadlineName: deadline, deadlineDate: deadlineDate)
            modelContext.insert(newItem)
        }
    }
}

#Preview {
    AddDeadlineSheetView()
        .modelContainer(for: Item.self, inMemory: true)
}
