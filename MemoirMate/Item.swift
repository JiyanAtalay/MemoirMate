//
//  Item.swift
//  MemoirMate
//
//  Created by Mehmet Jiyan Atalay on 5.11.2024.
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
