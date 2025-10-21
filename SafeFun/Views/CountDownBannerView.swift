//
//  CountDownBannerView.swift
//  SafeFun
//
//  Created by Facultad de Contaduría y Administración on 21/10/25.
//

import SwiftUI
internal import Combine

struct CountdownBannerView: View {
    
    // 1. State to hold the time components
    @State private var timeRemaining: (days: Int, hours: Int, minutes: Int, seconds: Int) = (0, 0, 0, 0)
    
    // 2. The target date: June 11, 2026, 17:00 UTC
    // We create it safely using DateComponents in the UTC timezone.
    private let targetDate: Date = {
        var components = DateComponents()
        components.year = 2026
        components.month = 6
        components.day = 11
        components.hour = 17 // 5:00 PM
        components.minute = 0
        components.second = 0
        components.timeZone = TimeZone(secondsFromGMT: 0) // UTC 0
        
        // Use the Gregorian calendar to create the date
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: components) ?? Date()
    }()
    
    // 3. A timer that fires every second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Background Image
            Image("stadium-banner") // Make sure you have an image named "stadium-banner" in your assets
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .overlay(Color.black.opacity(0.4)) // Dark overlay for text readability

            // Countdown Content
            VStack(spacing: 8) {
                Text("Countdown to Kickoff")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // HStack for the numbers
                HStack(spacing: 20) {
                    timeComponent(value: timeRemaining.days, label: "DAYS")
                    timeComponent(value: timeRemaining.hours, label: "HRS")
                    timeComponent(value: timeRemaining.minutes, label: "MIN")
                    timeComponent(value: timeRemaining.seconds, label: "SEC")
                }
            }
        }
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        .onReceive(timer) { _ in
            // 4. Update the time remaining every second
            updateTimeRemaining()
        }
    }
    
    // Helper view for each number (Days, Hours, etc.)
    private func timeComponent(value: Int, label: String) -> some View {
        VStack {
            Text(String(format: "%02d", value))
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.8))
        }
    }
    
    // Function to calculate the time difference
    private func updateTimeRemaining() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: Date(), to: targetDate)
        
        timeRemaining.days = components.day ?? 0
        timeRemaining.hours = components.hour ?? 0
        timeRemaining.minutes = components.minute ?? 0
        timeRemaining.seconds = components.second ?? 0
    }
}

struct CountdownBannerView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownBannerView()
            .padding()
            .background(Color.gray)
    }
}
