//
//  LaunchManager.swift
//  SafeFun
//
//  Created by Facultad de Contaduría y Administración on 21/10/25.
//

import Foundation
import SwiftUI
internal import Combine // <-- 1. Import Combine for the timer

class LaunchManager: ObservableObject {
    
    @Published var isLoading = true
    @Published var progress: Double = 0.0 // <-- 2. Track progress value
    
    private var timer: AnyCancellable? // <-- 3. To hold the timer

    init() {
        loadAppData()
    }
    
    func loadAppData() {
        print("App is loading data...")
        
        // 4. Start a timer to simulate loading
        timer = Timer.publish(every: 0.2, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                // 5. Increment progress
                var newProgress = self.progress + 0.1
                if newProgress > 1.0 {
                    newProgress = 1.0
                }
                
                // Animate the bar's movement
                withAnimation(.linear(duration: 0.2)) {
                    self.progress = newProgress
                }

                // 6. When loading is complete
                if self.progress >= 1.0 {
                    self.timer?.cancel() // Stop the timer
                    
                    // Add a small delay so the user sees the full bar
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            self.isLoading = false // Trigger the app switch
                        }
                    }
                }
            }
    }
}
