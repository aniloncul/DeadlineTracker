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
    @State var selectedCategory: Category = .socialEvent
    @State var selectedDeadlineType: Item.DeadlineType = .socialEvent
    
   
       
    enum  Category: String, CaseIterable, Identifiable {
        var id: Category { self }
        
        case payment, socialEvent, dailyRoutine, workReminder
        
        var selectedCategoryString: String {
            switch self {
            case .payment:
                return "Payment"
            case .socialEvent:
                return "Social Event"
            case .dailyRoutine:
                return "Daily Routine"
            case .workReminder:
                return "Work Reminder"
            }
        }
        
        var selectedCategoryColor: Color {
            switch self {
            case .payment:
                return Color.green
            case .socialEvent:
                return Color.red
            case .dailyRoutine:
                return Color.yellow
            case .workReminder:
                return Color.blue
            }
        }

    }
    
  
    
    private let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let minRange = calendar.date(byAdding: .minute, value: +1, to: Date())!
        let maxRange = calendar.date(byAdding: .year, value: 10, to:Date())!
        
        let timeRange = minRange...maxRange
        return timeRange
    }()
    
    
    
    var body: some View {
        
        VStack{
            
            HStack {
                Picker("Select Deadline Category", selection: $selectedCategory) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Text(category.selectedCategoryString)
                            .tag(category)
                            
                    }
                }
                .pickerStyle(.menu)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(selectedCategory.selectedCategoryColor)
                )
                .tint(.white)
                

                
            }
            .hSpacing(.topLeading)
            
            HStack {
                Picker("Select Deadline Category", selection:
                $selectedDeadlineType) {
                    ForEach(Item.DeadlineType.allCases, id: \.self) { category in
                        Text(category.selectedDeadlineTypeString)
                            .tag(category)
                            
                    }
                }
                .pickerStyle(.menu)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(selectedDeadlineType.selectedDeadlineTypeColor)
                )
                .tint(.white)
                

                
            }
            .hSpacing(.topLeading)
            
            
            
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
            let newItem = Item(timestamp: Date(), deadlineName: deadline, deadlineDate: deadlineDate, category: selectedCategory.selectedCategoryString, deadlineType: selectedDeadlineType ?? .dailyRoutine)
            modelContext.insert(newItem)
        }
    }
}

#Preview {
    AddDeadlineSheetView()
        .modelContainer(for: Item.self, inMemory: true)
}
