//
//  EventModel.swift
//  EventCalendar
//
//  Created by FTLSoft (Vahe) on 12.12.25.
//

import Foundation
import SwiftUI

enum EventType: String, Decodable {
    case work
    case birthday
    case activity
    case note
    
    var systemIconName: String {
        switch self {
        case .work: return "briefcase"
        case .birthday: return "birthday.cake.fill"
        case .activity: return "figure.run"
        case .note: return "pencil.and.list.clipboard"
        }
    }
    
    var iconFillColor: Color {
        switch self {
        case .work: return .yellow
        case .birthday: return .purple
        case .activity: return .green
        case .note: return .blue
        }
    }
}

struct Event: Hashable, Decodable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var type: EventType
    var date: Date
    var shortDescription: String
    var longDescription: String?
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case type
        case date
        case shortDescription
        case longDescription
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.title = try container.decode(String.self, forKey: .title)
        self.type = try container.decode(EventType.self, forKey: .type)
        self.date = try container.decode(Date.self, forKey: .date)
        self.shortDescription = try container.decode(String.self, forKey: .shortDescription)
        self.longDescription = try container.decodeIfPresent(String.self, forKey: .longDescription)
    }
    
    init (title: String, type: EventType, date: Date, shortDescription: String, longDescription: String? = nil) {
        self.title = title
        self.type = type
        self.date = date
        self.shortDescription = shortDescription
        self.longDescription = longDescription
    }
}

enum NavigationError: Error, LocalizedError {
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .networkError: return "Network connection failed"
        }
    }
}
