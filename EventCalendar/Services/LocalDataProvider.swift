//
//  LocalDataProvider.swift
//  EventCalendar
//
//  Created by FTLSoft (Vahe) on 12.12.25.
//

import Foundation

struct DaylyData: Decodable {
    let hasEvents: Bool
}

struct MonyhlyData: Decodable {
    let month: Date
}

typealias MonthRawData = [String: DaylyData]

final class LocalDataProvider {
    static let shared = LocalDataProvider()
    fileprivate let eventsFilename = "events.json"
    fileprivate let monthsFilename = "months.json"
    
    func loadMonthData(month: Date) -> [Date: DaylyData] {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: monthsFilename, withExtension: nil) else {
            fatalError("Couldn't find \(monthsFilename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(monthsFilename):\n\(error)")
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        do {
            let decoder = JSONDecoder()
            
            let raw = try decoder.decode([String: DaylyData].self, from: data)
            
            var result: [Date: DaylyData] = [:]
            
            for (key, value) in raw {
                if let date = formatter.date(from: key), date.monthAndYearString == month.monthAndYearString {
                    result[date] = value
                }
            }
            
            return result
        } catch {
            fatalError("Couldn't parse \(monthsFilename):\n\(error)")
        }
    }
    
    func loadEventsFor(day date: Date) -> [Event] {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: eventsFilename, withExtension: nil)
        else {
            fatalError("Couldn't find \(eventsFilename) in main bundle.")
        }
        
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(eventsFilename) from main bundle:\n\(error)")
        }
        
        
        do {
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(formatter)
            let events = try decoder.decode([Event].self, from: data).filter({ $0.date.startOfDay == date.startOfDay })
            return events
        } catch {
            fatalError("Couldn't parse \(eventsFilename) as \([Event].self):\n\(error)")
        }
    }
}
