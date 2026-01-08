//
//  Item.swift
//  Workout Tracking
//
//  Created by petch on 7/1/2569 BE.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
