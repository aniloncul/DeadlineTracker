//
//  Date+Extensions.swift
//  DeadlineTracker
//
//  Created by Anıl Öncül on 14.02.2024.
//

import Foundation

extension Date {
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    func fetchWeek(_ date: Date = .init()) -> [WeekDay] {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: date)
        
        var week: [WeekDay] = []
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        guard let startOfWeek = weekForDate?.start else {
            return []
        }
        
        (0..<7).forEach { index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
                week.append(.init(date: weekDay))
            }
        }
        
        return week
    }
    
    static func monthsInYear(_ date: Date) -> [String] {
           let formatter = DateFormatter()
           formatter.dateFormat = "MMMM"
           return (1...12).map { month in
               let newDate = Calendar.current.date(bySetting: .month, value: month, of: date)!
               return formatter.string(from: newDate)
           }
       }
       
       static func changeMonth(of date: Date, to month: String) -> Date {
           let formatter = DateFormatter()
           formatter.dateFormat = "MMMM"
           let newDate = formatter.date(from: month)!
           return Calendar.current.date(bySetting: .month, value: Calendar.current.component(.month, from: newDate), of: date)!
       }
    
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
}
