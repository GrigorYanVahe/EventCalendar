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
    private var monthDataTask: URLSessionDataTask?
    @Published var isEventDataLoading = false
    private var eventsDataTask: URLSessionDataTask?
    @Published var error: String?
    
    private let networkService = NetworkService.shared
    
    func loadMonthData(month: Date) async {
        isMonthDataLoading = true
        monthData.removeAll()
        monthDataTask?.cancel()
        
        self.monthDataTask = networkService.loadMonthData(for: month) { [weak self] result in
            DispatchQueue.main.async {
                self?.isMonthDataLoading = false
            }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.monthData = response
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error.localizedDescription
                }
            }
            self?.monthDataTask = nil
        }
    }
    
    func loadEventData(day: Date) async {
        isEventDataLoading = true
        events.removeAll()
        eventsDataTask?.cancel()
        
        eventsDataTask = networkService.loadEventData(for: day) { [weak self] result in
            DispatchQueue.main.async {
                self?.isEventDataLoading = false
            }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.events = response
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error.localizedDescription
                }
            }
            self?.eventsDataTask = nil
        }
    }
}
