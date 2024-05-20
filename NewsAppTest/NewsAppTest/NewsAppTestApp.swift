//
//  NewsAppTestApp.swift
//  NewsAppTest
//
//  Created by PunitNaik on 14/05/24.
//

import SwiftUI
import HomeModule

@main
struct NewsAppTestApp: App {
    private let homeRouter = HomeRouter()

    var body: some Scene {
        WindowGroup {
            homeRouter.buildDashboardView()
        }
    }
}
