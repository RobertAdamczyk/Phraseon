//
//  Date+TimeAgo.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 28.12.23.
//

import Foundation

extension Date {

    var timeAgo: String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = now < self ? now : self
        let latest = (earliest == now) ? self : now
        let components: DateComponents = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year], 
                                                                 from: earliest, to: latest)

        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        } else if let year = components.year, year >= 1 {
            return "1 year ago"
        } else if let month = components.month, month >= 2 {
            return "\(month) months ago"
        } else if let month = components.month, month >= 1 {
            return "1 month ago"
        } else if let week = components.weekOfYear, week >= 2 {
            return "\(week) weeks ago"
        } else if let week = components.weekOfYear, week >= 1 {
            return "1 week ago"
        } else if let day = components.day, day >= 2 {
            return "\(day) days ago"
        } else if let day = components.day, day >= 1 {
            return "Yesterday"
        } else if let hour = components.hour, hour >= 2 {
            return "\(hour) hours ago"
        } else if let hour = components.hour, hour >= 1 {
            return "An hour ago"
        } else if let minute = components.minute, minute >= 2 {
            return "\(minute) minutes ago"
        } else if let minute = components.minute, minute >= 1 {
            return "A minute ago"
        } else {
            return "Just now"
        }
    }
}
