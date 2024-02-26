//
//  View+Extensions.swift
//  DeadlineTracker
//
//  Created by Anıl Öncül on 14.02.2024.
//

import SwiftUI

extension View {
    @ViewBuilder
    func hSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    func vSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    func largeTitleStyle() -> some View {
          return self.modifier(LargeTitleStyle())
      }
    
    
}

struct LargeTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.largeTitle)
            .foregroundColor(.primary)
            .minimumScaleFactor(0.6)
            .lineLimit(1)
    }
}
