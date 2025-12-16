//
//  CalendarViewModel.swift
//  EventCalendar
//
//  Created by FTLSoft (Vahe) on 13.12.25.
//

import Foundation
import Combine


@MainActor
final class CalendarViewModel: ObservableObject {
    @Published var monthData: [Date: DaylyData] = [:]
    @Published var events: [Event] = []
    @Published var isMonthDataLoading = false
    @Published var isEventDataLoading = false
    @Published var error: String?

    private let service = NetworkService()

    func loadMonthData(month: Date) async {
        isMonthDataLoading = true
        monthData.removeAll()
        do {
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
            monthData = try await service.loadMonthData(for: month)
            print(monthData)
        } catch {
            self.error = error.localizedDescription
        }
        isMonthDataLoading = false
    }
    
    func loadEventData(day: Date) async {
        isEventDataLoading = true
        events.removeAll()
        do {
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
            events = try await service.loadEventData(for: day)
            print(events)
        } catch {
            self.error = error.localizedDescription
        }
        isEventDataLoading = false
    }
}
