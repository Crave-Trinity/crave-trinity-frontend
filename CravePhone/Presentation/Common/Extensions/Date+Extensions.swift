//
//  Date+Extensions.swift
//  CravePhone
//
//  Date formatting and manipulation extensions.
//

import Foundation

extension Date {
    // Format to a readable date
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
    
    // Format to a readable time
    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    // Format to a readable day and time
    func formattedDayAndTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, h:mm a"
        return formatter.string(from: self)
    }
    
    // Get relative time description (e.g., "2 hours ago", "Yesterday")
    func relativeTimeDescription() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    // Check if date is today
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    // Check if date is yesterday
    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    // Check if date is within the last week
    var isWithinLastWeek: Bool {
        guard let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else {
            return false
        }
        return self >= oneWeekAgo
    }
    
    // Format date contextually based on recency
    func smartDateString() -> String {
        if isToday {
            return "Today, " + formattedTime()
        } else if isYesterday {
            return "Yesterday, " + formattedTime()
        } else if isWithinLastWeek {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE" // Day name
            return formatter.string(from: self)
        } else {
            return formattedDate()
        }
    }
}
