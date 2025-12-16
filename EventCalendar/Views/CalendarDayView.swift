//
//  CalendarDayView.swift
//  EventCalendar
//
//  Created by FTLSoft (Vahe) on 13.12.25.
//

import SwiftUI

struct CalendarDayView: View {
    let isToday: Bool
    let day: Date
    var onDayTap: (Date) -> Void
    var hasEvents: Bool?
    
    var body: some View {
        Button(day.formatted(.dateTime.day())) {
            onDayTap(day)
        }
        .fontWeight(.heavy)
        .font(.system(size: 22, design: .rounded))
        .foregroundStyle(.white.opacity(0.9))
        .frame(maxWidth: .infinity, minHeight: (UIScreen.main.bounds.width - 16) / 7 )
        .background(
            Circle()
                .shadow(radius: 7)
                .foregroundStyle(
                    Date.now.startOfDay == day.startOfDay
                    ? .blue.opacity(0.6)
                    : .dayBackTransparent
                )
        )
        .overlay {
            Circle()
                .stroke(.white.opacity(0.8), lineWidth: isToday ? 3 : 0)
                .shadow(radius: 7)
                .overlay {
                    if hasEvents == true {
                        HStack(alignment: .bottom) {
                            VStack {
                                Spacer()
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundStyle(.green)
                            }
                            Spacer()
                        }
                    }
                }
        }
    }
}

#Preview {
    CalendarDayView(isToday: false, day: .now, onDayTap: { test in
    }, hasEvents: true)
}
