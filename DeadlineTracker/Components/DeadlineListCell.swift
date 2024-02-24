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
    @State var deadlineTime = Date()
    @State var timeIntervalDouble: Double = 0
    @State var maxTimeInterval: Double = 0
    @State var timeInterval = String()
    @State var currentTimeInterval: String = ""
    @State var timeRemaining: TimeInterval = 0
    @State var deadlineHour: String = ""
    @State var deadlineType: String = ""
    @State var deadlineTypeColor: Color = .accentColor
    @State var importance = ""
    
    @State private var currentTime = Date()
    @State private var days = 0
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0
    
    @State private var interval: String = ""
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var deadline: Date
    
    
    
    var body: some View {
        VStack(spacing: 6) {
            
            //
            //                Text(deadlineType)
            //                    .background(
            //                        RoundedRectangle(cornerRadius: 10)
            //                            .fill(deadlineTypeColor)
            //                    ).hSpacing(.topLeading)
            //                    .tint(.white)
            
            Text(title)
                .font(.title)
                .font(Font.custom("Grayfeld-Condensed-Book.otf", fixedSize: 20))
                .foregroundColor(deadlinePassed ? .red : .primary)
                .strikethrough(deadlinePassed)
                .hSpacing(.leading)
                .padding(8)
            
            
            
            
            if !deadlinePassed {
                Gauge(
                    value: timeIntervalDouble ,
                    in: 0...maxTimeInterval,
                    label: {
                        //                            Text("\(deadlineTime)");
                    },
                    currentValueLabel: {
                        Text(String(format: "%.0f%%", (timeIntervalDouble / maxTimeInterval) * 100))
                    },
                    minimumValueLabel: {
                        Text(deadlineHour)
                    }, maximumValueLabel: {
                        Text("")
                        
                    }
                )
                .tint(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.green]),
                        startPoint: .trailing,
                        endPoint: .leading
                    )
                )
                .padding(12)
            }
            
             if !deadlinePassed {
                Text(interval)
                    .hSpacing(.center)
            }
        }.onReceive(timer, perform: { _ in
            withAnimation {
                updateTimeRemaining()
            }
        }
        )
        
        
    }
    private var currentHourMinute: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let currentTime = Date()
        let formattedTime = dateFormatter.string(from: currentTime)
        return formattedTime
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
    
    
    func updateTimeRemaining() {
        let remaining = Calendar.current.dateComponents([.day, .hour,.minute,.second], from: Date(), to: deadlineTime)
        let day = remaining.day ?? 0
        let hour = remaining.hour ?? 0
        let minute = remaining.minute ?? 0
        let second = remaining.second ?? 0
        
        if (day>0) {
            interval = "\(day) days \(hour) hours \(minute) minutes \(second) seconds "
        } else {
            interval = "\(hour) hours \(minute) minutes \(second) seconds "
        }
        
        
    }
    
    
 
    }
//    func calculateRemainingTime() -> String {
//        let remainingTime = timeIntervalDouble - NSDate.timeIntervalSinceReferenceDate
//        let timeRemaining = max(remainingTime, 0)
//        
//        // Convert timeRemaining to a user-friendly format (e.g., hours, minutes, seconds).
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.hour, .minute, .second]
//        formatter.unitsStyle = .abbreviated
//        return formatter.string(from: timeRemaining) ?? "Expired"
//    }
    
    






#Preview {
    DeadlineListCell(deadline: Date())
}
