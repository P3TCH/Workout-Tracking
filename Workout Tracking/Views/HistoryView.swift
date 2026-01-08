//
//  HistoryView.swift
//  Workout Tracking
//
//  Created by petch on 7/1/2569 BE.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var currentMonthWorkouts: [WorkoutSession]
    
    init() {
            let calendar = Calendar.current
            let now = Date.now
            
            let components = calendar.dateComponents([.year, .month], from: now)
            let startOfMonth = calendar.date(from: components)!
            
            let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
            
            let predicate = #Predicate<WorkoutSession> { session in
                session.date >= startOfMonth && session.date < endOfMonth
            }
            
            _currentMonthWorkouts = Query(filter: predicate, sort: \WorkoutSession.date, order: .reverse)
        }
    
    private var groupedWorkouts: [(Date, [(String, [WorkoutSession])])] {
        let calendar = Calendar.current
        let dateGroups = Dictionary(grouping: currentMonthWorkouts) { calendar.startOfDay(for: $0.date) }
        
        return dateGroups.map { (date, workouts) in
            let muscleGroups = Dictionary(grouping: workouts) { $0.muscleGroup }
            return (date, muscleGroups.sorted { $0.key < $1.key })
        }.sorted { $0.0 > $1.0 }
    }

    var body: some View {
        NavigationStack {
            if currentMonthWorkouts.isEmpty {
                ContentUnavailableView("No History Yet",
                                       systemImage: "calendar.badge.exclamationmark",
                                       description: Text("Workouts for \(Date.now.formatted(.dateTime.month(.wide))) will appear here."))
            } else {
                List {
                    ForEach(groupedWorkouts, id: \.0) { date, muscleSections in
                        Section(header: Text(date.formatted(date: .long, time: .omitted)).font(.headline)) {
                            
                            ForEach(muscleSections, id: \.0) { muscle, sessions in
                                DisclosureGroup("\(muscle)") {
                                    ForEach(sessions) { session in
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(session.exerciseName)
                                                Text("\(session.completedSets)/\(session.totalSets) Sets")
                                                    .font(.caption).foregroundStyle(.secondary)
                                            }
                                            Spacer()
                                        }
                                    }
                                    .onDelete { indexSet in
                                        deleteSession(from: sessions, at: indexSet)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("History")
                .toolbarTitleDisplayMode(.inlineLarge)
                .toolbar {
                    EditButton()
                }
            }
        }
    }
    
    private func deleteSession(from sessions: [WorkoutSession], at offsets: IndexSet) {
            for index in offsets {
                let sessionToDelete = sessions[index]
                modelContext.delete(sessionToDelete)
            }

            try? modelContext.save()
        }
}

#Preview {
    HistoryView()

}
