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
    
    init(timestamp: Date, deadlineName: String, deadlineDate: Date) {
        self.timestamp = timestamp
        self.deadlineName = deadlineName
        self.deadlineDate = deadlineDate
    }
}
