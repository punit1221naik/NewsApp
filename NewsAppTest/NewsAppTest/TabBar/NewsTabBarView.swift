//
//  NewsTabBarView.swift
//  NewsAppTest
//
//  Created by PunitNaik on 20/05/24.
//

import SwiftUI

struct NewsTabBarView: View {
    @State private var selectedTab = TabItems.home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(TabItems.allCases, id: \.self)  { tabItem in
                tabItem.content
                    .tabItem {
                        Image(systemName: tabItem.iconName)
                            .symbolRenderingMode(.multicolor)
                            .frame(width: 180, height: 180)
                            .aspectRatio(contentMode: .fit)
                        Text(tabItem.title)
                    }
                    .tag(tabItem.tag)
            }
        }
        .toolbarColorScheme(.light, for: .tabBar)
    }
    
}

#Preview {
    NewsTabBarView()
}
