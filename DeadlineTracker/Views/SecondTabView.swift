//
//  SecondTabView.swift
//  DeadlineTracker
//
//  Created by Anıl Öncül on 17.02.2024.
//

import SwiftUI

struct SecondTabView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedDate = Date()
    @State private var afterSelectedMonth = Date()
    @State private var beforeSelectedMonth = Date()
    
        @State private var showDatePicker = false
        var body: some View {
            VStack {
                VStack {
                    VStack {
                        HStack {
                            Text("\(selectedDate, formatter: MMMDDYYYYFormatter)")
                                                       .font(Font.custom("Grayfeld-Condensed-Book.otf", size: 30).bold())
                                                       .textCase(.uppercase)
                                                       .foregroundColor(.primary)
                                                       .padding(.leading, 16)
                            Button {
                                showDatePicker.toggle()
                            } label: {
                                Image(systemName: "calendar.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .padding(.trailing)
                            }
                            .hSpacing(.topTrailing)
                        .padding(.trailing, 16)
                        }
                        
                        Group {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .center, spacing: 24) {
                                            
                                            Text("\(beforeSelectedMonth, formatter: MMMFormatter)")
                                                                       .font(Font.custom("Grayfeld-Condensed-Book.otf", size: 30).bold())
                                                                       .textCase(.uppercase)
                                                                       .foregroundColor(.secondary)
                                            
                                            Button(action: {
                                                           self.selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: self.selectedDate)!
                                                self.beforeSelectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: self.selectedDate)!
                                                self.afterSelectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: self.selectedDate)!
                                                       }) {
                                                           Image(systemName: "chevron.left.circle.fill")
                                                               .font(.title)
                                                               .foregroundColor(.blue)
                                                       }
                                            
                                            Text("\(selectedDate, formatter: MMMFormatter)")
                                                                       .font(Font.custom("Grayfeld-Condensed-Book.otf", size: 30).bold())
                                                                       .textCase(.uppercase)
                                                                       .foregroundColor(.primary)
                                            

                                            Button(action: {
                                                            self.selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: self.selectedDate)!
                                                self.beforeSelectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: self.selectedDate)!
                                                self.afterSelectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: self.selectedDate)!
                                                        }) {
                                                            Image(systemName: "chevron.right.circle.fill")
                                                                .font(.title)
                                                                .foregroundColor(.blue)
                                                        }
                                            
                                            Text("\(afterSelectedMonth, formatter: MMMFormatter)")
                                                                       .font(Font.custom("Grayfeld-Condensed-Book.otf", size: 30).bold())
                                                                       .textCase(.uppercase)
                                                                       .foregroundColor(.secondary)
                                        }
                                        .padding()
                            }.onAppear(perform: {
                                self.afterSelectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: self.selectedDate)!
                                self.beforeSelectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: self.selectedDate)!
                        })
                        }
                        .hSpacing(.center)
                        
                        
                        
                    }.sheet(isPresented: $showDatePicker) {
                        // Half-sheet view with DatePicker
                        DatePickerSheetView(selectedDate: $selectedDate)
                            .presentationDetents([.medium])
                            
                      
                    }
                    
                
                    
                   
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
    
    var MMMDDYYYYFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM.dd,YYYY"
            return formatter
        }
    
}


struct DatePickerSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDate: Date

    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .labelsHidden()
                .datePickerStyle(.graphical)
                .frame(maxHeight: 400)
            }
            .navigationBarItems(trailing:
                Button("Done") {
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    SecondTabView()
}
