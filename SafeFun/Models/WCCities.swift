//
//  WCCities.swift
//  SafeFun
//
//  Created by Facultad de Contaduría y Administración on 21/10/25.
//

import SwiftUI

struct USACitiesView: View {
    let usaCities = ["Atlanta", "Boston", "Dallas", "Houston", "Kansas City", "Los Angeles", "Miami", "New York", "Philadelphia", "Seattle", "San Francisco"]
    
    var body: some View {
        // Call the reusable view with USA-specific data
        CitiesView(countryName: "USA", cities: usaCities)
    }
}

struct CanadaCitiesView: View {
    let canadaCities = ["Toronto", "Vancouver"]
    
    var body: some View {
        // Call the reusable view with Canada-specific data
        CitiesView(countryName: "Canada", cities: canadaCities)
    }
}

struct MexicoCitiesView: View {
    let mexicoCities = ["Mexico City", "Guadalajara", "Monterrey"]
    
    var body: some View {
        // Call the reusable view with Mexico-specific data
        CitiesView(countryName: "Mexico", cities: mexicoCities)
    }
}


// --- PREVIEW ---
// You can preview any of your new views here
struct WorldCupCountryViews_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            // Preview the USA view
            USACitiesView()
            
            // You could also preview the others:
            // CanadaCitiesView()
            // MexicoCitiesView()
        }
    }
}
