//
//  Calendar+Extensions.swift
//  DeadlineTracker
//
//  Created by Anıl Öncül on 18.02.2024.
//

import Foundation

extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        return self.date(from: self.dateComponents([.year, .month], from: self.startOfDay(for: date)))!
    }

    func endOfMonth(for date: Date) -> Date {
        return self.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(for: date))!
    }
}
