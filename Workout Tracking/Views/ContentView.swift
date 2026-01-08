//
//  ContentView.swift
//  Workout Tracking
//
//  Created by petch on 7/1/2569 BE.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var workouts: [WorkoutSession]
    @State private var showingAddExercise = false
    
    init(today: Date) {
        _workouts = Query(
                    filter: #Predicate<WorkoutSession> {
                        $0.day == today
                    },
                    sort: \.date,
                    order: .reverse
                )
    }

    var body: some View {
        NavigationStack {
            if workouts.isEmpty {
                ContentUnavailableView("No Workouts Today",
               systemImage: "figure.strengthtraining.traditional",
               description: Text("Tap + to add your first exercise."))
            } else {
                List {
                    ForEach(workouts) { workout in
                        WorkoutRow(workout: workout)
                    }
                    .onDelete(perform: deleteWorkouts)
                }
                .navigationTitle("Workout Today")
                .toolbarTitleDisplayMode(.inlineLarge)
            }
        }
    }

    private func deleteWorkouts(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(workouts[index])
        }
        try? modelContext.save()
    }
}
