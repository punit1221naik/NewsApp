//
//  NewTabItemSource.swift
//  NewsAppTest
//
//  Created by PunitNaik on 20/05/24.
//

import Foundation
import HomeModule
import SwiftUI

protocol NewTabItemSource {
    var iconName: String { get  }
    var title: String { get  }
    var tag: Int { get  }
    var content: AnyView { get }
}


enum TabItems:  NewTabItemSource, CaseIterable {
    case home
    case health
    
    var iconName: String {
        switch self {
            case .home:
                "house"
            case .health:
                "heart.circle"
        }
    }
    
    var title: String {
        switch self {
            case .home:
                "house"
            case .health:
                "Health"
        }
    }
    
    var tag: Int {
        switch self {
            case .home:
                1
            case .health:
                2
        }
    }
    
    var content: AnyView {
        switch self {
            case .home:
                let homeRouter = HomeRouter()
                return AnyView(homeRouter.buildDashboardView())
            case .health:
                let healthRouter = HealthRouter()
                return AnyView(healthRouter.buildHealthView())
        }
    }
}
