//
//  SafeFunApp.swift
//  SafeFun
//
//  Created by Lalo Cardenas on 19/10/25.
//

import SwiftUI

@main
struct SafeFunApp: App {
    @StateObject private var launchManager = LaunchManager()
    
    var body: some Scene {
        WindowGroup {
            if launchManager.isLoading {
                LaunchLoadingView()
                    .environmentObject(launchManager) // <-- ADD THIS MODIFIER
            } else {
                RootView()
            }
        }
    }
}


// Your RootView remains unchanged as it handles its own logic
struct RootView: View {
    @State private var showCompleteProfile = false
    @State private var goToCommunities = false

    var body: some View {
        NavigationStack {
            WelcomeView()
        }
        .sheet(isPresented: $showCompleteProfile) {
            CompleteProfileView {
                showCompleteProfile = false
                goToCommunities = true
            }
            .interactiveDismissDisabled(true)
        }
    }
}
