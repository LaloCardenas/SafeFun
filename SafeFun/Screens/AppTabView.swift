//
//  AppTabView.swift
//  SafeFun
//
//  Created by Lalo Cardenas on 19/10/25.
//

import SwiftUI

private enum AppTab: Hashable {
    case communities
    case emergency
    case news
    case profile
}

struct AppTabView: View {
    @State private var selectedTab: AppTab = .emergency

    var body: some View {
        TabView(selection: $selectedTab) {
            CommunitiesView()
                .tabItem {
                    Label("Communities", systemImage: "person.3.fill")
                }
                .tag(AppTab.communities)

            EmergencyView()
                .tabItem {
                    Label("Emergency", systemImage: "exclamationmark.triangle.fill")
                }
                .tag(AppTab.emergency)

            NewsView()
                .tabItem {
                    Label("News", systemImage: "newspaper.fill")
                }
                .tag(AppTab.news)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
                .tag(AppTab.profile)
        }
    }
}

#Preview {
    AppTabView()
}
