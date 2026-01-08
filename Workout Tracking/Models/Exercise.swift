//
//  Exercise.swift
//  Workout Tracking
//
//  Created by petch on 7/1/2569 BE.
//

import Foundation

struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    let totalSets: Int
    var completedSets: Int
}
