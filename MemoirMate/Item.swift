//
//  Item.swift
//  MemoirMate
//
//  Created by Mehmet Jiyan Atalay on 5.11.2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var month: Int
    var year: Int
    var days: [Days] = []
    
    init(month: Int, year: Int) {
        self.month = month
        self.year = year
    }
    
    static func getCurrentMonth() -> Int {
        let currentDate = Date()
        let calendar = Calendar.current
        return calendar.component(.month, from: currentDate)
    }
        
    static func getCurrentYear() -> Int {
        let currentDate = Date()
        let calendar = Calendar.current
        return calendar.component(.year, from: currentDate)
    }
    
    static func getCurrentDay() -> Int {
        let currentDate = Date()
        let calendar = Calendar.current
        return calendar.component(.day, from: currentDate)
    }
    
    func getMonthName() -> String? {
        let locale = Locale(identifier: "tr_TR")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "MMMM"

        var components = DateComponents()
        components.month = month

        let calendar = Calendar.current
        if let date = calendar.date(from: components) {
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func getDayName(for day: Int) -> String? {
        let locale = Locale(identifier: "tr_TR")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "EEEE"

        var components = DateComponents()
        components.year = self.year
        components.month = self.month
        components.day = day

        let calendar = Calendar.current
        if let date = calendar.date(from: components) {
            return dateFormatter.string(from: date)
        }
        return nil
    }
}

@Model
final class Days {
    var id: UUID
    var day: Int
    var notes: [Notes]
    var summary: String
    
    init(day: Int) {
        self.id = UUID()
        self.day = day
        self.notes = []
        self.summary = ""
    }
    
    func getMonthName(month: Int) -> String? {
        let locale = Locale(identifier: "tr_TR")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "MMMM"

        var components = DateComponents()
        components.month = month

        let calendar = Calendar.current
        if let date = calendar.date(from: components) {
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func getDayName(day: Int, month: Int, year: Int) -> String? {
        let locale = Locale(identifier: "tr_TR")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "EEEE"

        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day

        let calendar = Calendar.current
        if let date = calendar.date(from: components) {
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    static func getCurrentDay() -> Int {
        let currentDate = Date()
        let calendar = Calendar.current
        return calendar.component(.day, from: currentDate)
    }
}

struct Notes: Codable, Identifiable, Equatable {
    var hour: Int
    var note: String
    
    var id: Int { hour }
    
    static func == (lhs: Notes, rhs: Notes) -> Bool {
        return lhs.hour == rhs.hour && lhs.note == rhs.note
    }
}
