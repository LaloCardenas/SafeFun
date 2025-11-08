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
        CitiesView(countryName: "USA", cities: usaCities)
    }
}

struct CanadaCitiesView: View {
    let canadaCities = ["Toronto", "Vancouver"]
    
    var body: some View {
        CitiesView(countryName: "Canada", cities: canadaCities)
    }
}

struct MexicoCitiesView: View {
    let mexicoCities = ["Mexico City", "Guadalajara", "Monterrey"]
    
    var body: some View {
        CitiesView(countryName: "Mexico", cities: mexicoCities)
    }
}
