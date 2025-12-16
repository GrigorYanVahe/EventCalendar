//
//  EventCalendarApp.swift
//  EventCalendar
//
//  Created by FTLSoft (Vahe) on 12.12.25.
//

import SwiftUI

@main
struct EventCalendarApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                CalendarView(coordinator: coordinator, viewModel: CalendarViewModel())
                .navigationDestination(for: AppRoute.self) { route in
                    destinationView(for: route)
                }
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .eventDetail(let event):
            EventDetailsView(coordinator: coordinator, event: event)
        }
    }
}
