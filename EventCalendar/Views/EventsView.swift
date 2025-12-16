//
//  EventsView.swift
//  EventCalendar
//
//  Created by FTLSoft (Vahe) on 15.12.25.
//

import SwiftUI

struct EventsView: View {
    let date: Date
    let events: [Event]
    var onTap: ((Event) -> Void)? = nil
    
    var body: some View {
        HStack {
            Text("Events - \(date.monthAndDayString)")
                .fontWeight(.black)
                .foregroundStyle(.white)
                .font(.system(size: 25, design: .rounded))
                .shadow(radius: 5)
                .contentTransition(.numericText())
                .animation(.easeInOut, value: date.monthAndDayString)
                .padding(.top)
            Spacer()
        }
        
        ScrollView {
            ForEach(events) { event in
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        HStack(alignment: .center) {
                            Image(systemName: event.type.systemIconName)
                                .frame(width: 35, height: 35)
                                .background(.dayBackTransparent)
                                .clipShape(.capsule)
                                .foregroundStyle(event.type.iconFillColor)
                                .shadow(radius: 7)
                            Text(event.title)
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                                .font(.system(size: 20, design: .rounded))
                                .shadow(radius: 5)
                        }
                        Spacer()
                        Text(event.date.dayAndTimeString)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .font(.system(size: 11, design: .rounded))
                            .shadow(radius: 5)
                            .padding(.trailing, 20)
                    }
                    .padding(.bottom)
                    Text(event.shortDescription)
                        .fontWeight(.thin)
                        .foregroundStyle(.white)
                        .font(.system(size: 14, design: .rounded))
                }
                .padding()
                .background(.dayBackTransparent)
                .cornerRadius(10)
                .overlay {
                    HStack(alignment: .center) {
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.white)
                            .padding(.trailing, 10)
                    }
                }
                .onTapGesture {
                    onTap?(event)
                }
            }
            .padding(.bottom)
        }
        .scrollIndicators(.never)
        .cornerRadius(10)

    }
}

#Preview {
    EventsView(date: .now, events: [Event(title: "test long title test long title", type: .work, date: .now, shortDescription: "test decription"),Event(title: "test", type: .activity, date: .now, shortDescription: "test decription test decription test decription test decription test decription test decription"),Event(title: "test", type: .birthday, date: .now, shortDescription: "test decription test decription test decription test decription")])
}
