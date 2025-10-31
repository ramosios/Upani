//
//  ContentView.swift
//  AniCue
//
//  Created by Jorge Ramos on 14/06/25.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: CustomTabBarView.Tab = .discover

    var body: some View {
        TabView(selection: $selectedTab) {
            DiscoverView()
                .tag(CustomTabBarView.Tab.discover)
                .tabItem {
                    Label(CustomTabBarView.Tab.discover.title, systemImage: CustomTabBarView.Tab.discover.iconName)
                }

            WatchlistView()
                .tag(CustomTabBarView.Tab.watchlist)
                .tabItem {
                    Label(CustomTabBarView.Tab.watchlist.title, systemImage: CustomTabBarView.Tab.watchlist.iconName)
                }
            MenuView(sourceType: .mainMenu)
                .tag(CustomTabBarView.Tab.games)
                .tabItem {
                    Label(CustomTabBarView.Tab.games.title, systemImage: CustomTabBarView.Tab.games.iconName)
                }

            ProfileView()
                .tag(CustomTabBarView.Tab.profile)
                .tabItem {
                    Label(CustomTabBarView.Tab.profile.title, systemImage: CustomTabBarView.Tab.profile.iconName)
                }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
