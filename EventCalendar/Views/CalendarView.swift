//
//  ContentView.swift
//  EventCalendar
//
//  Created by FTLSoft (Vahe) on 12.12.25.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var coordinator: AppCoordinator
    @StateObject var viewModel: CalendarViewModel
    
    @State private var monthDate = Date.now.startOfMonth
    @State private var selectedDate: Date? = nil
    
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    @State private var days: [Date] = []
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            VStack {
                HStack() {
                    Button(action: {
                        monthDate = monthDate.previousMonth
                    }) {
                        Image(systemName: "chevron.left")
                            .frame(width: 35, height: 35)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    
                    Spacer()
                    
                    Text(monthDate.monthAndYearString)
                        .fontWeight(.black)
                        .foregroundStyle(.white)
                        .font(.system(size: 25, design: .rounded))
                        .padding()
                        .shadow(radius: 5)
                        .contentTransition(.numericText())
                        .animation(.easeInOut, value: monthDate.monthAndYearString)
                    Spacer()
                    
                    Button(action: {
                        monthDate = monthDate.nextMonth
                    }) {
                        Image(systemName: "chevron.right")
                            .frame(width: 35, height: 35)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                }
                HStack {
                    ForEach(daysOfWeek.indices, id: \.self) { index in
                        Text(daysOfWeek[index])
                            .fontWeight(.black)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .shadow(radius: 7)
                    }
                }
                LazyVGrid(columns: columns) {
                    ForEach(days, id: \.self) { day in
                        if day.monthInt != monthDate.monthInt {
                            Spacer()
                        } else {
                            CalendarDayView(isToday: (selectedDate == day), day: day, onDayTap: { tappedDay in
                                if selectedDate == tappedDay {
                                    selectedDate = nil
                                } else {
                                    if selectedDate != nil {
//                                        await viewModel.loadEventData(day: selectedDate!)
                                    }
                                    selectedDate = tappedDay
                                }
                            }, hasEvents: viewModel.monthData[day]?.hasEvents)
                            .animation(.easeInOut, value: selectedDate?.dayInt)
                        }
                    }
                }
                
                if viewModel.isEventDataLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(1.6)
                }
                
                if !viewModel.events.isEmpty, selectedDate != nil {
                    EventsView(date: selectedDate!, events: viewModel.events) { event in
                        coordinator.navigate(to: .eventDetail(event))
                    }
                }
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width - 24)
            .onAppear {
                days = monthDate.calendarDisplayDays
            }
            .onChange(of: monthDate) {
                days = monthDate.calendarDisplayDays
            }
            .task(id: monthDate) {
                await viewModel.loadMonthData(month: monthDate)
            }
            .task(id: selectedDate) {
                if selectedDate == nil { return }
                await viewModel.loadEventData(day: selectedDate!)
            }
        }
    }
}

#Preview {
    CalendarView(coordinator: AppCoordinator(), viewModel: CalendarViewModel())
}
