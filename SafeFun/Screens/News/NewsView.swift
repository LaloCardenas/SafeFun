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
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Título principal
                        Text("News")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.primary)
                            .padding(.horizontal)
                            .padding(.top, 6)
                        
                        // --- MAIN BANNER ---
                        CountdownBannerView()
                        
                        // --- GROUPS SECTION (card) ---
                        NewsSectionCard(title: "Groups") {
                            // Header de navegación a lista completa
                            NavigationLink {
                                WCGroupsListView()
                            } label: {
                                HStack {
                                    Text("See all groups")
                                        .font(.subheadline.bold())
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 6)
                            }
                            .buttonStyle(.plain)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
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
                                .padding(.top, 6)
                            }
                        }
                        .padding(.horizontal)
                        
                        // --- USA CITIES SECTION (card) ---
                        NewsSectionCard(title: "USA") {
                            NavigationLink(destination: CitiesView(countryName: "USA", cities: usa.usaCities)) {
                                HStack {
                                    Text("See all cities")
                                        .font(.subheadline.bold())
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 6)
                            }
                            .buttonStyle(.plain)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(Array(usa.usaCities.enumerated()), id: \.element) { _, city in
                                        NavigationLink(destination: CitiesView(countryName: "USA", cities: usa.usaCities, initialCity: city)) {
                                            CityItem(city: city, image: city)
                                        }
                                    }
                                }
                                .padding(.top, 6)
                            }
                        }
                        .padding(.horizontal)
                        
                        // --- MEXICO CITIES SECTION (card) ---
                        NewsSectionCard(title: "MEXICO") {
                            NavigationLink(destination: CitiesView(countryName: "MEXICO", cities: mexico.mexicoCities)) {
                                HStack {
                                    Text("See all cities")
                                        .font(.subheadline.bold())
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 6)
                            }
                            .buttonStyle(.plain)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(Array(mexico.mexicoCities.enumerated()), id: \.element) { _, city in
                                        NavigationLink(destination: CitiesView(countryName: "MEXICO", cities: mexico.mexicoCities, initialCity: city)) {
                                            CityItem(city: city, image: city)
                                        }
                                    }
                                }
                                .padding(.top, 6)
                            }
                        }
                        .padding(.horizontal)
                        
                        // --- CANADA CITIES SECTION (card) ---
                        NewsSectionCard(title: "CANADA") {
                            NavigationLink(destination: CitiesView(countryName: "CANADA", cities: canada.canadaCities)) {
                                HStack {
                                    Text("See all cities")
                                        .font(.subheadline.bold())
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 6)
                            }
                            .buttonStyle(.plain)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(Array(canada.canadaCities.enumerated()), id: \.element) { _, city in
                                        NavigationLink(destination: CitiesView(countryName: "CANADA", cities: canada.canadaCities, initialCity: city)) {
                                            CityItem(city: city, image: city)
                                        }
                                    }
                                }
                                .padding(.top, 6)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 8)
                    }
                    .padding(.vertical, 16)
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
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding(.horizontal)
        }
    }
    
    struct GroupItem: View {
        var letter: String
        var image: String
        let imageSize: CGFloat = 140

        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                ZStack {
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(.white.opacity(0.12), lineWidth: 1)
                        )
                        .shadow(radius: 8, y: 4)
                }
                Text("Group \(letter)")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .fontWeight(.medium)
            }
        }
    }
    
    struct CityItem: View {
        var city: String
        var image: String
        let imageSize: CGFloat = 140
        
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                ZStack {
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(.white.opacity(0.12), lineWidth: 1)
                        )
                        .shadow(radius: 8, y: 4)
                }
                Text(city)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .fontWeight(.medium)
            }
            .frame(width: imageSize)
        }
        
    }
}

// MARK: - Local reusable SectionCard for NewsView

struct NewsSectionCard<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 6)

            VStack(spacing: 10) {
                content
            }
            .padding(14)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.1), lineWidth: 1)
            )
            .shadow(radius: 12, y: 6)
        }
    }
}

// You will need this for the preview to work

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
            .preferredColorScheme(.dark)
    }
}
