//
//  CitiesViews.swift
//  SafeFun
//
//  Created by Facultad de Contaduría y Administración on 20/10/25.
//
import SwiftUI


// --- DATA MODEL ---



// --- REUSABLE CITIES VIEW ---

struct CitiesView: View {
    let countryName: String
    let cities: [String]
    
    @State private var selectedCity: String
    
    var filteredNews: [NewsArticle] {
        return NewsArticle.allNewsArticles.filter { $0.city == selectedCity }
    }
    
    init(countryName: String, cities: [String], initialCity: String? = nil) {
        self.countryName = countryName
        self.cities = cities
        let defaultCity = cities.first ?? "Unknown"
        self._selectedCity = State(initialValue: initialCity ?? defaultCity)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .leading, spacing: 0) {
                
                // --- City selection scroll view ---
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(cities, id: \.self) { city in
                                Button(action: {
                                    withAnimation {
                                        selectedCity = city
                                    }
                                }) {
                                    Text(city)
                                        .font(.callout)
                                        .fontWeight(.medium)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(selectedCity == city ? Color.red : Color.white)
                                        .foregroundColor(selectedCity == city ? .white : .black.opacity(0.8))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                    }
                    .background(Color.white.opacity(0.5))
                    .onAppear {
                        proxy.scrollTo(selectedCity, anchor: .center)
                    }
                    .onChange(of: selectedCity) { newCity in
                        withAnimation {
                            proxy.scrollTo(newCity, anchor: .center)
                        }
                    }
                } // End of ScrollViewReader
                .padding(.bottom, 12)
                
                // --- Vertical News List ---
                List {
                    ForEach(filteredNews) { article in
                        NavigationLink(destination: ArticleDetailView(article: article)) {
                            ArticleRow(article: article)
                        }
                    }
                    .listRowBackground(Color.white.opacity(0.5))
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle(countryName)
        .navigationBarTitleDisplayMode(.inline)
    }
}


// --- REUSABLE ARTICLE ROW ---

struct ArticleRow: View {
    var article: NewsArticle
    
    var body: some View {
        HStack(spacing: 12) {
            Image(article.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .background(Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(article.title)
                        .font(.headline)
                        .lineLimit(1)
                    Spacer()
                    Text(article.publishDate, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text(article.fullText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}


// --- ARTICLE DETAIL VIEW ---
struct ArticleDetailView: View {
    let article: NewsArticle
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            ScrollView {
                
                VStack(spacing: 0) {
                    
                    Image(article.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 250)
                        .cornerRadius(20, corners: [.topLeft, .topRight])
                        .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text(article.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 16)
                            .padding(.horizontal)


                        HStack {
                            Text(article.author)
                                .font(.headline)
                            Spacer()
                            Text(article.publishDate, style: .date)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)


                        Divider()

                        Text(article.fullText)
                            .font(.body)
                            .padding(.bottom, 20)
                            .padding(.horizontal)

                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                    .padding(.horizontal)


                    
                }
            }
            .ignoresSafeArea(edges: .top)
            .padding(.top, 16)
            
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// --- EXTENSION FOR SPECIFIC CORNERS ---
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// --- SHAPE FOR SPECIFIC CORNERS ---
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct CitiesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArticleDetailView(article: NewsArticle.allNewsArticles[0])
        }
    }
}


