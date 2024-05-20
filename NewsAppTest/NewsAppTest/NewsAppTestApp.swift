//
//  NewsAppTestApp.swift
//  NewsAppTest
//
//  Created by PunitNaik on 14/05/24.
//

import SwiftUI
import SwiftData
import HomeModule

@main
struct NewsAppTestApp: App {
    private let homeRouter = HomeRouter()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            homeRouter.buildDashboardView()
//            DashboardView(viewModel: DashboardViewVM(homeService: nil))
        }
        .modelContainer(sharedModelContainer)
    }
}
