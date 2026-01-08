//
//  WorkoutSession.swift
//  Workout Tracking
//
//  Created by petch on 8/1/2569 BE.
//

import Foundation
import SwiftData

@Model // Required macro
final class WorkoutSession {
    var muscleGroup: String
    var exerciseName: String
    var totalSets: Int
    var completedSets: Int
    var date: Date
    var day: Date   // startOfDay
    
    init(muscleGroup: String, exerciseName: String, totalSets: Int, completedSets: Int = 0, date: Date = .now) {
        self.muscleGroup = muscleGroup
        self.exerciseName = exerciseName
        self.totalSets = totalSets
        self.completedSets = completedSets
        self.date = date
        self.day = Calendar.current.startOfDay(for: date)
    }
}
