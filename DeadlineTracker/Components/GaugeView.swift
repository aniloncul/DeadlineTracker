//
//  GaugeView.swift
//  DeadlineTracker
//
//  Created by Anıl Öncül on 12.02.2024.
//

import SwiftUI
import SwiftData

struct GaugeView: View {
    
    
    @State private var currentTime = Date()
    @State private var timeRemaining: TimeInterval = 0
    @State private var progress: Double = 0
    @State private var interval: String = ""
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    // Set your deadline date
    var deadline = Calendar.current.date(byAdding: .second, value: 300, to: Date()) ?? Date()
    
    func updateTimeRemaining() {
        let remaining = Calendar.current.dateComponents([.hour,.minute,.second], from: currentTime, to: deadline)
        let hour = remaining.hour ?? 0
        let minute = remaining.minute ?? 0
        let second = remaining.second ?? 0
        interval = "\(hour) : \(minute):\(second) "
        
    }

    var body: some View {
        VStack {
            Gauge(
                value: progress,
                in: 0...300, // Assuming Gauge value range is from 0 to 1
                label: {
                    Text("Label")
                },
                currentValueLabel: {
                    Text("CurrentValueLabel")
                }
            )
            .padding(12)
            Text(interval)
            Text("Time Remaining: \(formattedTime)")
                .padding(8)
        }
        .onReceive(timer, perform: { _ in
            updateTimeRemaining()
        })
    }

    private func calculateTimeRemaining() {
        let currentTime = Date()
        let timeInterval = deadline.timeIntervalSince(currentTime)
        
        // Ensure non-negative time remaining
        timeRemaining = max(timeInterval, 0)
        
        // Calculate progress value for the Gauge
        progress = 1 - (timeRemaining / deadline.timeIntervalSinceReferenceDate)
    }
    
    private var formattedTime: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: timeRemaining) ?? "Expired"
    }
}

#Preview {
    GaugeView()
}
