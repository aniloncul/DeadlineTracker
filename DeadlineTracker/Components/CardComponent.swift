//
//  CardComponent.swift
//  DeadlineTracker
//
//  Created by Anıl Öncül on 13.02.2024.
//

import SwiftUI
 
struct CardComponent: View {
    @State var currentTime: Double
    
    let title: String
    let startTime: Date
    let endTime: Date
    let startTimeDouble: Double
    let endTimeDouble: Double
    
   
    
    
//    init(title: String, startTime: Date, endTime: Date) {
//        self.title = title
//        self.startTime = startTime
//        self.endTime = endTime
//    }
    
    var body: some View {
        
        VStack{
            
            Text(title)
            Text(startTime.formatted(date: .long, time: .shortened))
            Text(endTime.formatted(date: .long, time: .shortened))
            
            Gauge(value: currentTime,
                  in: startTimeDouble...endTimeDouble, 
                  label: {
                Text("\(title)");
                }, 
                  currentValueLabel: {
                    Text(String(format: "%.0f%%", (
                        ( currentTime - startTimeDouble) / (endTimeDouble - startTimeDouble )
                    ) * 100 ))
                })
            
        }
    }
}

#Preview {
//    let title = ""
//    let startTime = Date()
//    let endTime = Date()
    CardComponent(currentTime: 480, title: "job 1", startTime: Date(), endTime: Date(), startTimeDouble: 300, endTimeDouble: 500)
}
