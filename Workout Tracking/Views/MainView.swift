//
//  MainView.swift
//  Workout Tracking
//
//  Created by petch on 8/1/2569 BE.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showAddSheet = false
    @State private var selectedTab: Int = 0
    @State private var today = Calendar.current.startOfDay(for: .now)
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
            TabView(selection: $selectedTab) {
                Tab("Home", systemImage: "house", value: 0) {
                    ContentView(today: today)
                }

                Tab("History", systemImage: "calendar", value: 1) {
                    HistoryView()
                }

                Tab("Add", systemImage: "plus", value: 2, role: .search) {
                    AddExerciseView(selectedTab: $selectedTab)
                }
            }
            .onChange(of: scenePhase) {
                if scenePhase == .active {
                    let newToday = Calendar.current.startOfDay(for: .now)
                    if newToday != today {
                        today = newToday
                    }
                }
            }
        }
}


#Preview {
    MainView()
        .modelContainer(for: Item.self, inMemory: true)
}

