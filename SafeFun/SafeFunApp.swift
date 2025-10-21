//
//  SafeFunApp.swift
//  SafeFun
//
//  Created by Lalo Cardenas on 19/10/25.
//

import SwiftUI

@main
struct SafeFunApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    @State private var showCompleteProfile = false
    @State private var goToCommunities = false

    var body: some View {
        NavigationStack {
            WelcomeView()
        }
        .sheet(isPresented: $showCompleteProfile) {
            CompleteProfileView{
                showCompleteProfile = false
                goToCommunities = true
            }
                .interactiveDismissDisabled(true)
        }
    }
}
