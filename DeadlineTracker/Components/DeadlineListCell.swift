//
//  DeadlineListCell.swift
//  DeadlineTracker
//
//  Created by Anıl Öncül on 20.10.2023.
//

import SwiftUI

struct DeadlineListCell: View {
//    @State  var now: NSDate
//    @State var now_init = Date.now
//    init(now: Date) {
//        self.now = now
//    }
    @State var title: String = ""
    @State var deadlineTime: String = ""
    @State var timeIntervalDouble = Double()
    @State var maxTimeInterval = Double()
    
    
    
    var body: some View {
        
        VStack{
            Text(title)
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                .bold()
            
            Gauge(
                value: timeIntervalDouble,
                in: 0...maxTimeInterval,
                label: {
                    Text("deadline time: \(deadlineTime)");
                    Text("\(timeIntervalDouble)")
                },
                currentValueLabel: { 
                    Text(String(format: "%.0f%%", (timeIntervalDouble / maxTimeInterval) * 100))
                }
            )
            .padding(16)
            .onAppear {
                            // Animate the gauge when it appears on screen
                            withAnimation(.linear(duration: 1.0)) {
                                timeIntervalDouble = maxTimeInterval
                            }
                            // Start the timer to update the gauge each second
                            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                                withAnimation {
                                    timeIntervalDouble = max(0, timeIntervalDouble - 1)
                                }
                            }
                        }
        }
        .border(Color.green)
        .padding(10)
        .clipShape(.rect(cornerRadius: 10))
        .onChange(of: timeIntervalDouble) {
                    withAnimation(.linear(duration: 1.0)) {
                        // Animate the gauge when timeIntervalDouble changes
                    }
                }
            

            
            
        
    }
    
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

#Preview {
    DeadlineListCell(/*now: NSDate.now as NSDate*/)
}
