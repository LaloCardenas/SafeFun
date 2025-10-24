//
//  LaunchLoadingView.swift
//  SafeFun
//
//  Created by Facultad de Contaduría y Administración on 21/10/25.
//

import SwiftUI

struct LaunchLoadingView: View {
    // 1. Get the manager from the environment
    @EnvironmentObject var launchManager: LaunchManager
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 25) { // Increased spacing
                
                // 2. Your Logo
                // !! Replace "shield.lefthalf.filled" with your logo's name: Image("AppLogo")
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(LinearGradient(colors: [.wcPurple, .wcCyan], startPoint: .top, endPoint: .bottom))
                    .cornerRadius(20) // <-- Adjust the radius
                    .padding(.bottom, 10)

                ProgressView(value: launchManager.progress)                    .progressViewStyle(LinearProgressViewStyle(tint: .wcCyan))
                    .scaleEffect(y: 2, anchor: .center) // Make the bar thicker
                    .clipShape(Capsule()) // Round the bar's ends
                    .padding(.horizontal, 20)
                
            }
            .padding(40)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(.white.opacity(0.15), lineWidth: 1)
            )
            .shadow(radius: 20, y: 8)
        }
    }
}
