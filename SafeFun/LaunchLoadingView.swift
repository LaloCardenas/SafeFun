//
//  LaunchLoadingView.swift
//  SafeFun
//
//  Created by Facultad de Contaduría y Administración on 21/10/25.
//

import SwiftUI

struct LaunchLoadingView: View {

    @EnvironmentObject var launchManager: LaunchManager
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 25) {

                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(LinearGradient(colors: [.wcPurple, .wcCyan], startPoint: .top, endPoint: .bottom))
                    .cornerRadius(20)
                    .padding(.bottom, 10)

                ProgressView(value: launchManager.progress)                    .progressViewStyle(LinearProgressViewStyle(tint: .wcCyan))
                    .scaleEffect(y: 2, anchor: .center)
                    .clipShape(Capsule())
                    .padding(.horizontal, 20)
                
            }
            .padding(40)
        }
    }
}
