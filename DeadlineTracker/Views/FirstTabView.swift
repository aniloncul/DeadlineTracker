//
//  FirstTabView.swift
//  DeadlineTracker
//
//  Created by Anıl Öncül on 17.02.2024.
//

//
//  ContentView.swift
//  DeadlineTracker
//
//  Created by Anıl Öncül on 20.10.2023.
//

import SwiftUI
import SwiftData
import SwiftUIIntrospect

struct Book: Identifiable, Hashable {
    var id: UUID { UUID() }
    var title: String
    var author: String
}

struct FirstTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State var showLanguageListView: Bool = false
    
    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 0
    
    @State private var selectedCategory: Category?
    @State private var selectedDeadlineType: Item.DeadlineType?
    
    @State private var currentTimeInterval: Double = 0
    
    enum DeadlineHeader {
        case Today, Upcoming, Overdue
    }
    
    
    
    @State private var deadlineHeaderPicker: DeadlineHeader?
    
    private var colorArray = [Color.blue, Color.gray, Color.indigo, Color.cyan ]
    
    var showsIndicator: ScrollIndicatorVisibility = .hidden
    var showingPagingControl: Bool = true
    var pagingControlSpacing: CGFloat = 20
    var spacing: CGFloat = 10
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .black
        
        let attributes: [NSAttributedString.Key:Any] = [
            .foregroundColor : UIColor.white
        ]
        
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
    }
    
    var body: some View {
        
        
        NavigationView {
            VStack {
                
                
                //                            Picker("Select Deadline", selection: $deadlineHeaderPicker) {
                //                                Text("Today").tag(DeadlineHeader.Today)
                //                                Text("Upcoming").tag(DeadlineHeader.Upcoming)
                //                                Text("Overdue").tag(DeadlineHeader.Overdue)
                //
                //                            }
                //
                //                            .listRowInsets(.init())
                //                            .listRowBackground(Color.clear)
                //                            .pickerStyle(SegmentedPickerStyle())
                //                            .pickerStyle(.segmented)
                //                            .introspect(.picker(style: .segmented), on: .iOS(.v17)) {segmentedControl in
                //
                //                                segmentedControl.layer.cornerRadius = 12
                //                                segmentedControl.layer.borderColor = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0).cgColor
                //                                segmentedControl.layer.borderWidth = 0
                //                                segmentedControl.layer.masksToBounds = true
                //
                //                                segmentedControl.clipsToBounds = true}
                //
                
                VStack {
                    //MARK: - SegmentedPicker
                        SegmentedPicker(
                            selection: $deadlineHeaderPicker,
                            items: Binding(
                                get: { [DeadlineHeader.Today, .Upcoming, .Overdue] },
                                set: { _ in }
                            ),
                            selectionColor: .black
                        ) { header in
                            Text(header == .Today ? "Today" : (header == .Upcoming ? "Upcoming" : "Overdue"))
                    }
                    
                    //MARK: - Header
                    VStack{
                        HStack(alignment: .center) {
                            Group {
                                VStack(alignment: .center) {
                                    Text("\(Date().formatted(.dateTime.weekday(.wide)))")
                                        .font(Font.custom("Grayfeld-Condensed-Book.otf", size: 20))
                                        .fontWeight(.thin)
                                        .hSpacing(.topLeading)
                                    Text("\(Date(), formatter: customDateFormatter)")
                                        
                                        .font(Font.custom("Grayfeld-Condensed-Book.otf", size: 56))
                                        .hSpacing(.topLeading)
                                    Text("\(Date(), formatter: MMMFormatter)")
                                        .font(Font.custom("Grayfeld-Condensed-Book.otf", size: 56))
                                        
                                        .textCase(.uppercase)
                                        .hSpacing(.topLeading)
                                }
                                .padding(.leading, 24)
                               
                            }
//                            .padding(2)
//                            .padding(.leading, 16)
                            
                            Rectangle()
                                .frame(width: 1, height: 72)
                                .foregroundColor(Color.black)
                            
                            
                            
                            VStack(alignment: .trailing) {
                                
                                Text("Social Events: \(socialEvents.count)")
                                    .padding(.trailing, 16)
                                Text("Payments: \(payments.count)")
                                    .padding(.trailing, 16)
                                Text("Daily Routines: \(dailyRoutines.count)")
                                    .padding(.trailing, 16)
                                Text("Work Reminders: \(workReminders.count)")
                                    .padding(.trailing, 16)
                            }.hSpacing(.centerLastTextBaseline)
                        }
                    }
                    
                    //MARK: - Start of ScrollView
                    
//                    ScrollView(.horizontal) {
//                        HStack {
//                            ForEach(Array(highImportantEvents.enumerated().sorted { $0.element.deadlineDate < $1.element.deadlineDate }), id: \.element.id) { (index, item) in
//                                let currentTimeInterval = item.deadlineDate.timeIntervalSince(Date())
//                                let formattedTime = formatTimeInterval(currentTimeInterval)
//                                
//                                
//                                VStack {
//                                    Text( item.deadlineName)
//                                    Text("\(item.deadlineDate.formatted(.dateTime.day().month().year().hour().minute().second()))")
//                                    Text(  "\(formattedTime)")
//                                }.background(RoundedRectangle(cornerRadius: 10).foregroundColor(colorArray[index % colorArray.count]))
//                                
//                                
//                            }
//                        }
//                    }
                    
                    //MARK: - List
                    VStack(spacing: 24){
                        List {
                            Section {
                                ForEach(Array(filteredItems.enumerated().sorted { $0.element.deadlineDate < $1.element.deadlineDate }), id: \.element.id) { (index, item) in
                                    let currentDate = Date()
                                    let startOfToday = Calendar.current.startOfDay(for: currentDate)
                                    let currentTimeInterval = item.deadlineDate.timeIntervalSince(Date())
                                    let maxTimeInterval = item.deadlineDate.timeIntervalSince(startOfToday)
                                    let totalSeconds = Double(maxTimeInterval)
                                    let formattedTime = formatTimeInterval(currentTimeInterval)
                                    
                                    DeadlineListCell(
                                        title: item.deadlineName, deadlineTime: item.deadlineDate/*.formatted(.dateTime.day().month().year().hour().minute().second()))*/, timeIntervalDouble: currentTimeInterval, maxTimeInterval: totalSeconds, timeInterval: formattedTime, deadlineHour: item.deadlineDate.formatted(.dateTime.hour().minute()),  deadlineType: item.deadlineType.selectedDeadlineTypeString, deadlineTypeColor: item.deadlineType.selectedDeadlineTypeColor, importance: item.importance.rawValue, deadline: item.deadlineDate
                                    )
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(RoundedRectangle(cornerRadius: 18).foregroundColor(colorArray[index % colorArray.count]))
                                }
                                .onDelete(perform: deleteItems)
                            }
                            
                        }
                        .listStyle(PlainListStyle())
                       
                   }
                    .background(Color(red: 0.99, green: 0.99, blue: 0.99))
                    .clipShape(
                        .rect(
                                topLeadingRadius: 40,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 40
                            )
                    )
                    .padding(0)
                    .toolbar {
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
            }.background(Color(red: 0.82, green: 0.82, blue: 0.82))
          
            .sheet(isPresented: $showLanguageListView, content: {
                AddDeadlineSheetView()
            })
        }
    }
    
    private var highImportantEvents: [Item] {
        items.filter { $0.importance == .highImportant }
    }
    
    private var socialEvents: [Item] {
        items.filter { $0.deadlineType == .socialEvent }
    }
    
    private var workReminders: [Item] {
        items.filter { $0.deadlineType == .workReminder }
    }
    
    private var dailyRoutines: [Item] {
        items.filter { $0.deadlineType == .dailyRoutine }
    }
    
    private var payments: [Item] {
        items.filter { $0.deadlineType == .payment }
    }
    
    private var filteredItems: [Item] {
        let startOfNextDay = Calendar.current.startOfDay(for: Date().addingTimeInterval(24 * 60 * 60))
        
        switch deadlineHeaderPicker {
        case .Today:
            return items.filter { Calendar.current.isDateInToday($0.deadlineDate) && $0.deadlineDate > Date() }
        case .Upcoming:
            return items.filter { $0.deadlineDate >= startOfNextDay }
        case .Overdue:
            return items.filter { $0.deadlineDate < Date() }
        case .none:
            return items.filter { Calendar.current.isDateInToday($0.deadlineDate) && $0.deadlineDate > Date() }
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
    
    private func date2Number (_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: date)
        
        if let day = components.day, let hour = components.hour, let minute = components.minute, let second = components.second {
            let result = day * 1000 + hour * 100 + minute * 10 + second
            return result
        }
        
        return 0
    }
    
    private func formatTimeInterval(_ totalSeconds: TimeInterval) -> String {
        let secondsInMinute: TimeInterval = 60
        let secondsInHour: TimeInterval = 3600
        let secondsInDay: TimeInterval = 86400
        
        let days = Int(totalSeconds / secondsInDay)
        let hours = Int((totalSeconds.truncatingRemainder(dividingBy: secondsInDay)) / secondsInHour)
        let minutes = Int((totalSeconds.truncatingRemainder(dividingBy: secondsInHour)) / secondsInMinute)
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: secondsInMinute))
        
        if (days > 0) {
            return String(format: "%02d:%02d:%02d:%02d", days, hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
    
    private func openAddSheetView() {
        
        withAnimation {
            let newItem = Item(timestamp: Date(), deadlineName: String(), deadlineDate: Date(),  deadlineType: selectedDeadlineType ?? .dailyRoutine, importance: .lessImportant)
            modelContext.insert(newItem)
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date(), deadlineName: String(), deadlineDate: Date(),  deadlineType: selectedDeadlineType ?? .dailyRoutine, importance: .lessImportant)
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
    FirstTabView()
        .modelContainer(for: Item.self, inMemory: true)
}
