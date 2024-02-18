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
    
    private var colorArray = [Color.blue, Color.gray, Color.indigo, Color.cyan ]
    
    @State private var showDatePicker = false
    var body: some View {
        ZStack {
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
                    ZStack {
                        VStack(spacing:0){
                            Spacer().frame(height: 20)
                            Group {
                                
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
                                .onAppear(perform: {
                                    self.afterSelectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: self.selectedDate)!
                                    self.beforeSelectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: self.selectedDate)!
                                }
                                )
                            }
                            
                            List {
                                ForEach(remainingDaysInMonth(), id: \.self) { day in
                                    Section {
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack{
                                                VStack {
                                                    Text("\(day.formatted(.dateTime.weekday(.wide)))")
                                                        .font(Font.custom("Grayfeld-Condensed-Book.otf", size: 20))
                                                        .hSpacing(.topLeading)
                                                        
                                                    Text("\(day, formatter: customDateFormatter)")
                                                        .font(Font.custom("Grayfeld-Condensed-Book.otf", size: 48).bold())
                                                        .hSpacing(.topLeading)
                                                    Text("\(day, formatter: MMMFormatter)")
                                                        .font(Font.custom("Grayfeld-Condensed-Book.otf", size: 48).bold())
                                                        .textCase(.uppercase)
                                                        .hSpacing(.topLeading)
                                                }
                                                .foregroundStyle(Color.black)
                                                .frame(width: 134)
                                                Rectangle()
                                                    .frame(width: 1, height: 120)
                                                    .foregroundColor(Color.black)
                                                VStack() {
                                                    ScrollView() {
                                                        ForEach(filteredItemsByDay(day: day)) { item in
                                                            HStack() {
                                                                Text(item.deadlineDate.formatted(.dateTime.hour().minute()) + "  " + item.deadlineName)
                                                                    .font(Font.custom("Grayfeld-Condensed-Book.otf", size: 16))
                                                                    .foregroundColor(.primary)
                                                                    .hSpacing(.leading)
                                                                    .padding(.bottom, 2)
                                                            }
                                                        }
                                                    }.padding(.vertical, 8)
                                                }
                                            }
                                        }
                                    }.listSectionSpacing(12)
                                        .listRowBackground(colorArray[remainingDaysInMonth().firstIndex(of: day)! % colorArray.count])
                                        .listStyle(InsetGroupedListStyle())
                                    
                                }
                                
                            }.scrollContentBackground(.hidden)
                           
                        }
//                        .background(Color.yellow)
//                        .hSpacing(.center)
                    }
                    .background(UnevenRoundedRectangle(cornerRadii: .init(
                        topLeading: 16.0,
                        bottomLeading: 0,
                        bottomTrailing: 0.0,
                        topTrailing: 16.0)))
                    .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                }
                .sheet(isPresented: $showDatePicker) {
                    DatePickerSheetView(selectedDate: $selectedDate)
                        .presentationDetents([.medium])
                }
            }
            .vSpacing(.topTrailing)
        }.background(Color.yellow)
    }
    
    
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
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
    
    private func remainingDaysInMonth() -> [Date] {
        guard let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: selectedDate)),
              let endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) else {
            return []
        }
        
        let dateRange = stride(from: startOfMonth.timeIntervalSinceReferenceDate, to: endOfMonth.timeIntervalSinceReferenceDate, by: 24 * 60 * 60)
            .map { Date(timeIntervalSinceReferenceDate: $0) }
        
        let remainingDays = dateRange.filter { $0 >= selectedDate }
        
        return remainingDays
    }
    
    private func filteredItemsByDay(day: Date) -> [Item] {
        let startOfDay = Calendar.current.startOfDay(for: day)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // Convert the ClosedRange to an array of Date objects
        let dateRange = startOfDay...endOfDay
        
        return items.filter { dateRange.contains($0.deadlineDate) }
    }
    
    private func filteredItemsByMonth() -> [Item] {
        let startOfMonth = Calendar.current.startOfMonth(for: selectedDate)
        let endOfMonth = Calendar.current.endOfMonth(for: selectedDate)
        
        return items.filter {
            $0.deadlineDate >= startOfMonth && $0.deadlineDate <= endOfMonth
        }
        .sorted { $0.deadlineDate < $1.deadlineDate }
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



//struct CalendarCardComponent: View {
//    @Query private var items: [Item]
//    var body: some View {
//        List {
//            ForEach(filteredItemsByMonth()) { item in
//                Text(item.deadlineName)
//            }
//        }
//    }
//}


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
