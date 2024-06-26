//
//  Item.swift
//  DeadlineTracker
//
//  Created by Anıl Öncül on 20.10.2023.
//

import SwiftUI
import SwiftData

@Model
final class Item {
  
    var timestamp: Date
    var deadlineName: String
    var deadlineDate: Date
   
    var deadlineType: DeadlineType
    var importance: Importance
    
    init(timestamp: Date, deadlineName: String, deadlineDate: Date,  deadlineType: DeadlineType, importance: Importance) {
        self.timestamp = timestamp
        self.deadlineName = deadlineName
        self.deadlineDate = deadlineDate
    
        self.deadlineType = deadlineType
        self.importance = importance
    }
    
    
    enum DeadlineType: String, Codable, CaseIterable, Identifiable {
        var id: DeadlineType { self }
        
        case payment, socialEvent, dailyRoutine, workReminder
        
        var selectedDeadlineTypeString: String {
            switch self {
            case .payment:
                return "Payment"
            case .socialEvent:
                return "Social Event"
            case .dailyRoutine:
                return "Daily Routine"
            case .workReminder:
                return "Work Reminder"
            }
        }
        
        var selectedDeadlineTypeColor: Color {
            switch self {
            case .payment:
                return Color.green
            case .socialEvent:
                return Color.red
            case .dailyRoutine:
                return Color.yellow
            case .workReminder:
                return Color.blue
            }
        }

    }
    
    enum Importance: String, Codable, CaseIterable, Identifiable {
        var id: Importance { self }
        
        case lessImportant, midImportant, highImportant
        
        var selectedImportant: String {
            switch self {
            case .lessImportant:
                return "!"
            case .midImportant:
                return "!!"
            case .highImportant:
                return "!!!"
            }
        }
    }
    

}
