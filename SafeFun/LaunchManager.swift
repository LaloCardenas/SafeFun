//
//  LaunchManager.swift
//  SafeFun
//
//  Created by Facultad de Contaduría y Administración on 21/10/25.
//

import Foundation
import SwiftUI
internal import Combine 

class LaunchManager: ObservableObject {
    
    @Published var isLoading = true
    @Published var progress: Double = 0.0
    
    private var timer: AnyCancellable?

    init() {
        loadAppData()
    }
    
    func loadAppData() {
        timer = Timer.publish(every: 0.2, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                var newProgress = self.progress + 0.1
                if newProgress > 1.0 {
                    newProgress = 1.0
                }
                
                withAnimation(.linear(duration: 0.2)) {
                    self.progress = newProgress
                }

                if self.progress >= 1.0 {
                    self.timer?.cancel()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            self.isLoading = false
                        }
                    }
                }
            }
    }
}
