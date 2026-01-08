//
//  WorkoutRow.swift
//  Workout Tracking
//
//  Created by petch on 8/1/2569 BE.
//

import SwiftUI

struct WorkoutRow: View {
    @Bindable var workout: WorkoutSession // Links directly to the database
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(workout.exerciseName)
                    .font(.headline)
                Text(workout.muscleGroup)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Set Tracker Controls
            HStack(spacing: 15) {
                // Remove set (Error correction)
                Button {
                    if workout.completedSets > 0 { workout.completedSets -= 1 }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundStyle(workout.completedSets > 0 ? .red : .gray)
                }
                .buttonStyle(.plain)

                // Current Progress
                Text("\(workout.completedSets) / \(workout.totalSets)")
                    .font(.system(.body, design: .monospaced))
                    .fontWeight(.bold)
                
                // Add set (Mark as done)
                Button {
                    if workout.completedSets < workout.totalSets {
                        workout.completedSets += 1
                    }
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(workout.completedSets == workout.totalSets ? .green : .blue)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 4)
        .sensoryFeedback(.impact, trigger: workout.completedSets) // 2026 Haptic
    }
}
