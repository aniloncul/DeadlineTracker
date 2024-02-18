//
//  SecondTabView.swift
//  DeadlineTracker
//
//  Created by Anıl Öncül on 17.02.2024.
//

import SwiftData
import SwiftUI

struct SecondTabView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Query private var items: [Item]
    
    @State private var selectedDate = Date()
    @State private var afterSelectedMonth = Date()
    @State private var beforeSelectedMonth = Date()
    
        @State private var showDatePicker = false
        var body: some View {
            VStack {
                VStack {
                    VStack {
                        HStack {
                            Text("\(selectedDate, formatter: MMMDDYYYYFormatter)")
                                .font(Font.custom("Grayfeld-Condensed-Book.otf", size: 30).bold())
                                .textCase(.uppercase)
                                .foregroundColor(.primary)
                                .padding(.leading, 16)
                            Button {
                                showDatePicker.toggle()
                            } label: {
                                Image(systemName: "calendar.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .padding(.trailing)
                            }
                            .hSpacing(.topTrailing)
                            .padding(.trailing, 16)
                        }
                        
                        Group {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .center, spacing: 24) {
                                    
                                    Text("\(beforeSelectedMonth, formatter: MMMFormatter)")
                                        .font(Font.custom("Grayfeld-Condensed-Book.otf", size: 30).bold())
                                        .textCase(.uppercase)
                                        .foregroundColor(.secondary)
                                    
                                    Button(action: {
                                        self.selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: self.selectedDate)!
                                        self.beforeSelectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: self.selectedDate)!
                                        self.afterSelectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: self.selectedDate)!
                                    }) {
                                        Image(systemName: "chevron.left.circle.fill")
                                            .font(.title)
                                            .foregroundColor(.blue)
                                    }
                                    
                                    Text("\(selectedDate, formatter: MMMFormatter)")
                                        .font(Font.custom("Grayfeld-Condensed-Book.otf", size: 30).bold())
                                        .textCase(.uppercase)
                                        .foregroundColor(.primary)
                                    
                                    
                                    Button(action: {
                                        self.selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: self.selectedDate)!
                                        self.beforeSelectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: self.selectedDate)!
                                        self.afterSelectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: self.selectedDate)!
                                    }) {
                                        Image(systemName: "chevron.right.circle.fill")
                                            .font(.title)
                                            .foregroundColor(.blue)
                                    }
                                    
                                    Text("\(afterSelectedMonth, formatter: MMMFormatter)")
                                        .font(Font.custom("Grayfeld-Condensed-Book.otf", size: 30).bold())
                                        .textCase(.uppercase)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                            }.onAppear(perform: {
                                self.afterSelectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: self.selectedDate)!
                                self.beforeSelectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: self.selectedDate)!
                            })
                        }
                        .hSpacing(.center)
                        List {
                            ForEach(items.sorted { $0.deadlineDate < $1.deadlineDate }) { (item) in
                                let currentTimeInterval = item.deadlineDate.timeIntervalSince(Date())
                                let maxTimeInterval = item.deadlineDate.timeIntervalSince(item.timestamp)
                                let totalSeconds = Double(maxTimeInterval)
                                
                                
                                DeadlineListCell(
                                    title: item.deadlineName,
                                    deadlineTime: "\(item.deadlineDate.formatted(.dateTime.day().month().year().hour().minute().second()))",
                                    timeIntervalDouble: currentTimeInterval,
                                    maxTimeInterval: totalSeconds,
                                    
                                    deadlineHour: item.deadlineDate.formatted(.dateTime.hour().minute()),
                                    deadline: item.deadlineDate
                                )
                                .background(RoundedRectangle(cornerRadius: 10))
                                
                                
                                
                            }.onDelete(perform: deleteItems)
                        }
                        
                    }
                    .sheet(isPresented: $showDatePicker) {
                        DatePickerSheetView(selectedDate: $selectedDate)
                            .presentationDetents([.medium])
                    }
                }
                .vSpacing(.topTrailing)
             }
        }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
    var customDateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM"
            return formatter
        }
    
    var MMMFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            return formatter
        }
    
    var MMMDDYYYYFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM.dd,YYYY"
            return formatter
        }
    
}


struct DatePickerSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDate: Date

    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .labelsHidden()
                .datePickerStyle(.graphical)
                .frame(maxHeight: 400)
            }
            .navigationBarItems(trailing:
                Button("Done") {
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    SecondTabView()
}
