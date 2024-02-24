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
    @State var selectedImportance: Item.Importance = .lessImportant
    @State var selectedDeadlineType: Item.DeadlineType = .socialEvent
    
     
    private let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let minRange = calendar.date(byAdding: .minute, value: +1, to: Date())!
        let maxRange = calendar.date(byAdding: .year, value: 10, to:Date())!
        
        let timeRange = minRange...maxRange
        return timeRange
    }()
    
    
    
    var body: some View {
        
        Form{
            
           
            Section {
                HStack(spacing: 20) {
                    Circle().fill(selectedDeadlineType.selectedDeadlineTypeColor).frame(width: 15)
                    Picker("Deadline Type:", selection:
                            $selectedDeadlineType) {
                        ForEach(Item.DeadlineType.allCases, id: \.self) { category in
                            Text(category.selectedDeadlineTypeString)
                                .tag(category)
                            
                        }
                    }
                            .pickerStyle(.menu)
                    
                }
            }
         
            
            
            Section {
                TextField("Enter your deadline",
                          text: $deadline
                )
                
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                .font(.headline).keyboardType(.default)
            }
                Section {
                
                DatePicker(
                    "Select Deadline",
                    selection: $deadlineDate,
                    in: dateRange,
                    displayedComponents: [.date, .hourAndMinute]
                ).datePickerStyle(.compact)
            }
            
            Section {
                Picker("Importance", selection: $selectedImportance) {
                    ForEach(Item.Importance.allCases, id: \.self) { importance in
                        Text(importance.selectedImportant)
                            .tag(importance)
                             
                   }
                             
                }
                .pickerStyle(.segmented)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.teal)
                )
                .tint(.white)
          }
            .hSpacing(.topLeading)
            
            
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
            let newItem = Item(timestamp: Date(), deadlineName: deadline, deadlineDate: deadlineDate,  deadlineType: selectedDeadlineType , importance: selectedImportance)
            modelContext.insert(newItem)
        }
    }
}

#Preview {
    AddDeadlineSheetView()
        .modelContainer(for: Item.self, inMemory: true)
}
