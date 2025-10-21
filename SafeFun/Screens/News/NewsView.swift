//
//  NewsView.swift
//  SafeFun
//
//  Created by Lalo Cardenas on 19/10/25.
//

import SwiftUI

// --- MAIN VIEW ---
struct NewsView: View {

    let mexico = MexicoCitiesView()
    let usa = USACitiesView()
    let canada = CanadaCitiesView()
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        Text("News")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        // --- MAIN BANNER ---
                        CountdownBannerView()
                        
                        Divider()
                        
                        // --- GROUPS SECTION ---
                        VStack(alignment: .leading, spacing: 12) {
                            NavigationLink(destination: WCGroupsListView()) {
                                SectionHeader(title: "Groups")
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    
                                    NavigationLink(destination: WCGroupDetailView(group: WCGroup.sampleWCGroupA)) {
                                        GroupItem(letter: "A", image: "Group A")
                                    }
                                    NavigationLink(destination: WCGroupDetailView(group: WCGroup.sampleWCGroupB)) {
                                        GroupItem(letter: "B", image: "Group B")
                                    }
                                    NavigationLink(destination: WCGroupDetailView(group: WCGroup.sampleWCGroupC)) {
                                        GroupItem(letter: "C", image: "Group C")
                                    }
                                    NavigationLink(destination: WCGroupDetailView(group: WCGroup.sampleWCGroupD)) {
                                        GroupItem(letter: "D", image: "Group D")
                                    }
                                    NavigationLink(destination: WCGroupDetailView(group: WCGroup.sampleWCGroupE)) {
                                        GroupItem(letter: "E", image: "Group A")
                                    }
                                    NavigationLink(destination: WCGroupDetailView(group: WCGroup.sampleWCGroupF)) {
                                        GroupItem(letter: "F", image: "Group B")
                                    }
                                    NavigationLink(destination: WCGroupDetailView(group: WCGroup.sampleWCGroupG)) {
                                        GroupItem(letter: "G", image: "Group C")
                                    }
                                    NavigationLink(destination: WCGroupDetailView(group: WCGroup.sampleWCGroupH)) {
                                        GroupItem(letter: "H", image: "Group D")
                                    }
                                    NavigationLink(destination: WCGroupDetailView(group: WCGroup.sampleWCGroupI)) {
                                        GroupItem(letter: "I", image: "Group A")
                                    }
                                    NavigationLink(destination: WCGroupDetailView(group: WCGroup.sampleWCGroupJ)) {
                                        GroupItem(letter: "J", image: "Group B")
                                    }
                                    NavigationLink(destination: WCGroupDetailView(group: WCGroup.sampleWCGroupK)) {
                                        GroupItem(letter: "K", image: "Group C")
                                    }
                                    NavigationLink(destination: WCGroupDetailView(group: WCGroup.sampleWCGroupL)) {
                                        GroupItem(letter: "L", image: "Group D")
                                    }
                                    
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        Divider()
                        
                        // --- USA CITIES SECTION ---
                        VStack(alignment: .leading, spacing: 12) {
                            NavigationLink(destination: CitiesView(countryName: "USA", cities: usa.usaCities)) {
                                SectionHeader(title: "USA")
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(Array(usa.usaCities.enumerated()), id: \.element) { index, city in
                                        NavigationLink(destination: CitiesView(countryName: "USA", cities: usa.usaCities, initialCity: city)) {
                                            CityItem(city: city, image: city)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        Divider()
                        
                        // --- MEXICO CITIES SECTION ---
                        VStack(alignment: .leading, spacing: 12) {
                            NavigationLink(destination: CitiesView(countryName: "MEXICO", cities: mexico.mexicoCities)) {
                                SectionHeader(title: "MEXICO")
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(Array(mexico.mexicoCities.enumerated()), id: \.element) { index, city in
                                        NavigationLink(destination: CitiesView(countryName: "MEXICO", cities: mexico.mexicoCities, initialCity: city)) {
                                            CityItem(city: city, image: city)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        Divider()
                        
                        // --- CANADA CITIES SECTION ---
                        VStack(alignment: .leading, spacing: 12) {
                            NavigationLink(destination: CitiesView(countryName: "CANADA", cities: canada.canadaCities)) {
                                SectionHeader(title: "CANADA")
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(Array(canada.canadaCities.enumerated()), id: \.element) { index, city in
                                        NavigationLink(destination: CitiesView(countryName: "CANADA", cities: canada.canadaCities, initialCity: city)) {
                                            CityItem(city: city, image: city)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationBarHidden(true)
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    
    // --- HELPER VIEWS ---
    
    struct FilterButton: View {
        var text: String
        var icon: String
        var body: some View {
            Button(action: {}) {
                Label(text, systemImage: icon)
                    .font(.callout).fontWeight(.medium)
                    .foregroundColor(.black.opacity(0.8))
                    .padding(.vertical, 8).padding(.horizontal, 12)
                    .background(Color.white.opacity(0.7))
                    .clipShape(Capsule())
            }
        }
    }
    
    struct SectionHeader: View {
        var title: String
        var body: some View {
            HStack {
                Text(title).font(.title2).fontWeight(.bold)
                Spacer()
                Image(systemName: "chevron.right").font(.callout).foregroundColor(.gray)
            }
            .padding(.horizontal)
        }
    }
    
    struct GroupItem: View {
        var letter: String
        var image: String
        let imageSize: CGFloat = 140

        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                ZStack {
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Text("Group \(letter)").font(.headline).fontWeight(.medium)
            }
        }
    }
    
    struct CityItem: View {
        var city: String
        var image: String
        let imageSize: CGFloat = 140
        
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                ZStack {
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Text(city).font(.headline).fontWeight(.medium)
            }
            .frame(width: imageSize)
        }
        
    }
}

// You will need this for the preview to work

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}

