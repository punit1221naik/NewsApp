//
//  Item.swift
//  NewsAppTest
//
//  Created by PunitNaik on 14/05/24.
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
