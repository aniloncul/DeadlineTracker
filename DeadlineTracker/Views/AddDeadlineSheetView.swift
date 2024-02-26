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
    
    @State var selectedRepeat = "Everyday"
    @State private var showOptions: Bool = false
    @State private var showDays: Bool = false
    @State private var toggleOperator: Bool = false
    
    
    let repeatTypes = ["Everyday", "Every Week Day", "Every Weekend","Selected Days"]

    
     
    private let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let minRange = calendar.date(byAdding: .minute, value: +1, to: Date())!
        let maxRange = calendar.date(byAdding: .year, value: 10, to:Date())!
        
        let timeRange = minRange...maxRange
        return timeRange
    }()
    
    
    
    var body: some View {
        NavigationView {
            ZStack {
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
                       
                        
                        Picker("Repeat", selection: $selectedRepeat) {
                            ForEach(repeatTypes, id: \.self) { repeattype in
                                Text(repeattype).tag(repeattype)
                            }
                        }.onChange(of: selectedRepeat) {_ in
                            showOptions = true
                        }
                        
                        if showOptions {
                            Section {
                                DisclosureGroup("additional options") {
                                    Text("anan")
                                    Text("baban")
                                }
                            }
                        }
                        
                        
                        
                    }
                    
                                    

                    Section {
                        Picker("Importance", selection: $selectedImportance) {
                            ForEach(Item.Importance.allCases, id: \.self) { importance in
                                Text(importance.selectedImportant)
                                
                                    .tag(importance)
                                    
                                    
                            }
                            
                        }
                        
                        .pickerStyle(.segmented)
                        .tint(.white)
                    }
                    .hSpacing(.topLeading)
                    
                    Section {
                        Toggle("repeat", isOn: $toggleOperator)
                        
                        if toggleOperator {
                            Picker("Repeat", selection: $selectedRepeat) {
                                ForEach(repeatTypes, id: \.self) { repeattype in
                                    Text(repeattype).tag(repeattype)
                                }
                            }.pickerStyle(.inline)
                                
//                            Section {
//                                DisclosureGroup("additional options") {
//                                    Text("anan")
//                                    Text("baban")
//                                }
//                            }
                        }
                    }
                    
                    
                }
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            addItem()
                            dismiss()
                        } label: {
                            Label("Save", systemImage: "")
                        }
                        
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Label("Cancel", systemImage: "")
                        }
                        
                    }
                }.navigationTitle("New Deadline")
                
            }
        }
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
