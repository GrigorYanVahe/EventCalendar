//
//  Coordinator.swift
//  EventCalendar
//
//  Created by FTLSoft (Vahe) on 15.12.25.
//


import SwiftUI
import Combine

protocol Coordinator: ObservableObject {
    associatedtype Route: Hashable
    var path: NavigationPath { get set }
    func navigate(to route: Route)
    func pop()
    func popToRoot()
}

enum AppRoute: Hashable {
    case eventDetail(Event)
}

class AppCoordinator: Coordinator {
    @Published var path = NavigationPath()
    @Published var alertMessage: String?
    @Published var showAlert = false
    
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func handleError(_ error: NavigationError) {
        alertMessage = error.localizedDescription
        showAlert = true
    }
}
