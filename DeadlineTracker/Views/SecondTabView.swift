//
//  SecondTabView.swift
//  DeadlineTracker
//
//  Created by Anıl Öncül on 17.02.2024.
//

import SwiftUI

struct SecondTabView: View {
    @State private var selectedDate = Date()
        @State private var showDatePicker = true
        var body: some View {
            VStack {
                VStack {
                    HStack {
                        VStack{
                            Group {
                                Text("\(selectedDate.formatted(.dateTime.weekday(.wide)))")
                                    .font(Font.custom("Grayfeld-Condensed-Book.otf", size: 20))
                                    .hSpacing(.topLeading)
                                Text("\(selectedDate, formatter: customDateFormatter)")
                                    .font(Font.custom("Grayfeld-Condensed-Book.otf", size: 48).bold())
                                    .hSpacing(.topLeading)
                                Text("\(selectedDate, formatter: MMMFormatter)")
                                    .font(Font.custom("Grayfeld-Condensed-Book.otf", size: 48).bold())
                                    .textCase(.uppercase)
                                    .hSpacing(.topLeading)
                            }.padding(2)
                        }

                        Button {
                            showDatePicker.toggle()
                        } label: {
                            Image(systemName: "calendar.circle")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding(.trailing)
                        }
                        
                    }
                    
                   
                    if showDatePicker {
                        DatePicker(
                            "",
                            selection: $selectedDate,
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        .datePickerStyle(.graphical)
                        .frame(maxHeight: 400)
                    }
                    DatePicker(
                        "",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                   
                }
                .vSpacing(.topTrailing)
             
            }
        }
    
    var customDateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM"
            return formatter
        }
    
    var MMMFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            return formatter
        }
    
}

#Preview {
    SecondTabView()
}
