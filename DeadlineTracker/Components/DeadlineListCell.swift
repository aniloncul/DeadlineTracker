//
//  DeadlineListCell.swift
//  DeadlineTracker
//
//  Created by Anıl Öncül on 20.10.2023.
//

import SwiftUI
import SwiftData

struct DeadlineListCell: View {
    @Environment(\.modelContext) var modelContext
    @Query var items: [Item]
    
    @State var title: String = ""
    @State var deadlineTime: String = ""
    @State var timeIntervalDouble: Double = 0
    @State var maxTimeInterval: Double = 0
    @State var timeInterval = String()
    @State var currentTimeInterval: String = ""
    @State var timeRemaining: TimeInterval = 0
    @State var deadlineHour: String = ""
    
    @State private var currentTime = Date()
    @State private var days = 0
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0
    
    @State private var interval: String = ""
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var deadline: Date
    
    func updateTimeRemaining() {
        let remaining = Calendar.current.dateComponents([.day, .hour,.minute,.second], from: currentTime, to: deadline)
        let day = remaining.day ?? 0
        let hour = remaining.hour ?? 0
        let minute = remaining.minute ?? 0
        let second = remaining.second ?? 0
        interval = "\(day) days \(hour) hours \(minute) minutes \(second) seconds "
        
    }
    
    
    
    var body: some View {
        VStack {
            VStack{
                Text(title)
                    .foregroundColor(deadlinePassed ? .red : .primary)
                    .strikethrough(deadlinePassed)
                    .bold()
                    .hSpacing(.leading)
                Text(deadlineHour)
                    .hSpacing(.leading)
                
//                Gauge(
//                    value: timeIntervalDouble ,
//                    in: 0...maxTimeInterval,
//                    label: {
//                        Text("\(deadlineTime)");
//                    },
//                    currentValueLabel: {
//                        Text(String(format: "%.0f%%", (timeIntervalDouble / maxTimeInterval) * 100))
//                    }
//                )
                
                .padding(12)
                
                
                if !deadlinePassed {
                    Text(interval)
                        .hSpacing(.center)
                    
                    
                }
                
            }
            
            
            .padding(12) // Add padding
           
            
        }.onReceive(timer, perform: { _ in
            updateTimeRemaining()
        })
        
        
    }
    
    
    private var formattedTime: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: timeRemaining) ?? "Expired"
    }
    
    private var deadlinePassed: Bool {
        return timeIntervalDouble < 0
    }
    
    //    private func updateComponents(from remainingTime: Double) {
    //            let secondsInMinute: Double = 60
    //            let secondsInHour: Double = 3600
    //            let secondsInDay: Double = 86400
    //
    //        let remaining = Calendar.current.dateComponents([.hour,.minute,.second], from: Date(), to: deadline)
    //        let hour = remaining.hour ?? 0
    //        let minute = remaining.minute ?? 0
    //        let second = remaining.second ?? 0
    //        timeRemaining = "\(hour) : \(minute):\(second) "
    //
    //
    //
    //            days = Int(remainingTime / secondsInDay)
    //            hours = Int((remainingTime.truncatingRemainder(dividingBy: secondsInDay)) / secondsInHour)
    //            minutes = Int((remainingTime.truncatingRemainder(dividingBy: secondsInHour)) / secondsInMinute)
    //            seconds = Int(remainingTime.truncatingRemainder(dividingBy: secondsInMinute))
    //
    //        }
    func calculateRemainingTime() -> String {
        let remainingTime = timeIntervalDouble - NSDate.timeIntervalSinceReferenceDate
        let timeRemaining = max(remainingTime, 0)
        
        // Convert timeRemaining to a user-friendly format (e.g., hours, minutes, seconds).
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: timeRemaining) ?? "Expired"
    }
    
    
}





//#Preview {
//    DeadlineListCell(/*now: NSDate.now as NSDate*/, deadline: <#Date#>)
////}
