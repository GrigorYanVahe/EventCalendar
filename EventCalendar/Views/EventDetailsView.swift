//
//  EventDetailsView.swift
//  EventCalendar
//
//  Created by FTLSoft (Vahe) on 15.12.25.
//

import SwiftUI

struct EventDetailsView: View {
    @ObservedObject var coordinator: AppCoordinator
    let event: Event
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            VStack(alignment: .center) {
                HStack(alignment: .top) {
                    HStack(alignment: .center) {
                        Image(systemName: event.type.systemIconName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                            .foregroundStyle(event.type.iconFillColor)
                            .padding()
                        VStack(alignment: .leading) {
                            Text(event.title)
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                                .font(.system(size: 20, design: .rounded))
                                .shadow(radius: 5)
                            Text(event.shortDescription)
                                .fontWeight(.thin)
                                .foregroundStyle(.white)
                                .font(.system(size: 14, design: .rounded))
                            
                        }
                    }
                    
                    Spacer()
                }
                .background(.dayBackTransparent)
                .cornerRadius(20)
                
                if event.longDescription != nil, event.longDescription != "" {
                    HStack(alignment: .top) {
                        Text(event.longDescription ?? "")
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .font(.system(size: 15, design: .rounded))
                            .shadow(radius: 5)
                    }
                    .padding()
                    .background(.dayBackTransparent)
                    .cornerRadius(20)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    coordinator.pop()
                }) {
                    Image(systemName: "chevron.left")
                        .frame(width: 35, height: 35)
                        .background(.clear)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .buttonStyle(.plain)
            }
            
            ToolbarItem(placement: .principal) {
                Text("Event Details")
                    .font(.system(size: 25, design: .rounded))
                    .fontWeight(.black)
                    .foregroundStyle(.white)
                    .shadow(radius: 5)
            }
        }
    }
}

#Preview {
    EventDetailsView(coordinator: AppCoordinator(), event: Event(title: "test", type: .activity, date: .now, shortDescription: "Event test short description", longDescription: "Event test short description, Event test short description, Event test short description, Event test short description Event test short description Event test short description Event test short description Event test short description"))
}
