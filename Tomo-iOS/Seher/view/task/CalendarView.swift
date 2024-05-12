//
//  CalendarView.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/8/23.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    @State private var xOffset: CGFloat = 0
    
    // Static date formatters for efficiency
    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }()
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    var body: some View {
        VStack {
            Text(month)
                .font(.title2)
                .padding(.bottom, 10)

            dayNamesView
                .padding(.bottom, 10)
            
            datesView
                .offset(x: xOffset)
                .highPriorityGesture(calendarDragGesture)
        }
    }
    
    private var month: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }
    
    private var dayNamesView: some View {
        HStack {
            ForEach(0..<7) { index in
                Text(day(for: index))
                    .frame(width: 32, height: 32)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }
    
    private var datesView: some View {
        HStack {
            ForEach(0..<7) { index in
                let dateForIndex = Calendar.current.date(byAdding: .day, value: index, to: startOfWeek(from: selectedDate))!
                Button(action: {
                    selectedDate = dateForIndex
                }) {
                    Text(date(for: index))
                        .frame(width: 32, height: 32)
                        .background(Color.blue.opacity(isDateSelected(dateForIndex) ? 0.3 : 0))
                        .foregroundColor(isDateSelected(dateForIndex) ? .blue : .gray)
                        .cornerRadius(8)
                }
            }
        }
    }
    
    private func isDateSelected(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(selectedDate, equalTo: date, toGranularity: .day)
    }
    
    private var calendarDragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                xOffset = value.translation.width
            }
            .onEnded { value in
                handleDragEnd(value)
            }
    }
    
    // Utility functions
    private func day(for index: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: index, to: startOfWeek(from: selectedDate))!
        return Self.dayFormatter.string(from: date)
    }
    
    private func date(for index: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: index, to: startOfWeek(from: selectedDate))!
        return Self.dateFormatter.string(from: date)
    }
    
    private func currentDate() -> String {
        return Self.dateFormatter.string(from: Date())
    }
    
    private func startOfWeek(from date: Date) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: date)
        let offset = components.weekday! - Calendar.current.firstWeekday
        components.day! -= offset
        return Calendar.current.date(from: components)!
    }
    
    private func handleDragEnd(_ value: DragGesture.Value) {
        withAnimation {
            if xOffset > 50 {
                selectedDate = Calendar.current.date(byAdding: .day, value: -7, to: selectedDate)!
                xOffset = -UIScreen.main.bounds.width
            } else if xOffset < -50 {
                selectedDate = Calendar.current.date(byAdding: .day, value: 7, to: selectedDate)!
                xOffset = UIScreen.main.bounds.width
            } else {
                xOffset = 0
            }
        }
        
        // Reset the offset after the animation is complete.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            xOffset = 0
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
