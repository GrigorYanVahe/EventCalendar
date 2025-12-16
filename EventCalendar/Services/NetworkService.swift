//
//  NetworkService.swift
//  EventCalendar
//
//  Created by FTLSoft (Vahe) on 12.12.25.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    
    func loadEventData(for day: Date) async throws -> [Event] {
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
        }
        return LocalDataProvider.shared.loadEventsFor(day: day)
    }
    
    func loadMonthData(for month: Date) async throws -> [Date: DaylyData] {
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
        }
        return LocalDataProvider.shared.loadMonthData(month: month)
    }
}
