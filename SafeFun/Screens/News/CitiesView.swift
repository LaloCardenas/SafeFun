//
//  CitiesViews.swift
//  SafeFun
//
//  Created by Facultad de Contaduría y Administración on 20/10/25.
//
import SwiftUI

// --- REUSABLE CITIES VIEW ---

struct CitiesView: View {
    let countryName: String
    let cities: [String]
    
    @State private var selectedCity: String
    
    var filteredNews: [NewsArticle] {
        NewsArticle.allNewsArticles.filter { $0.city == selectedCity }
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
                
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(cities, id: \.self) { city in
                                CityChipCompact(
                                    title: city,
                                    isSelected: selectedCity == city
                                ) {
                                    selectedCity = city
                                    proxy.scrollTo(city, anchor: .center)
                                }
                                .id(city)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                    }
                    .background(
                        .ultraThinMaterial,
                        in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(.white.opacity(0.10), lineWidth: 0.8)
                    )
                    .padding(.horizontal)
                    .padding(.top, 6)

                }
                .padding(.bottom, 10)
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredNews) { article in
                            NavigationLink {
                                ArticleDetailView(article: article)
                            } label: {
                                ArticleCardRow(article: article)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                        }
                        Spacer(minLength: 8).frame(height: 8)
                    }
                    .padding(.top, 4)
                }
            }
        }
        .navigationTitle(countryName)
        .navigationBarTitleDisplayMode(.inline)
    }
}


private struct CityChipCompact: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(isSelected ? .white : .primary)
                    .lineLimit(1)
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(
                Capsule(style: .continuous)
                    .fill(isSelected ? Color.wcPurple : Color.white.opacity(0.08))
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(isSelected ? .white.opacity(0.22) : .white.opacity(0.12), lineWidth: 0.8)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct ArticleCardRow: View {
    var article: NewsArticle
    
    var body: some View {
        HStack(spacing: 12) {
            Image(article.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(.white.opacity(0.12), lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text(article.title)
                        .font(.subheadline.weight(.semibold))
                        .lineLimit(2)
                        .foregroundStyle(.primary)
                    Spacer()
                    Text(article.publishDate, style: .date)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Text(article.fullText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
        .shadow(radius: 6, y: 3)
    }
}

struct ArticleDetailView: View {
    let article: NewsArticle
    
    let cornerRadius: CGFloat = 18

    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    Spacer(minLength: 12)
                        .frame(height: 12)
                    
                    Image(article.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, minHeight: 210, maxHeight: 250)
                        .clipShape(TopRoundedRectangle(radius: cornerRadius))
                        .overlay(
                            TopRoundedRectangle(radius: cornerRadius)
                                .stroke(.white.opacity(0.15), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        .padding(.top, 6)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(article.title)
                            .font(.title3.bold())
                            .foregroundStyle(.primary)
                        
                        HStack {
                            Text(article.author)
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(article.publishDate, style: .date)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Divider().opacity(0.12)
                        
                        Text(article.fullText)
                            .font(.body)
                            .foregroundStyle(.primary)
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 20)
                    .background(
                        .ultraThinMaterial,
                        in: BottomRoundedRectangle(radius: cornerRadius)
                    )
                    .overlay(
                        BottomRoundedRectangle(radius: cornerRadius)
                            .stroke(.white.opacity(0.12), lineWidth: 1)
                    )
                    .shadow(radius: 10, y: 5)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TopRoundedRectangle: Shape {
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius), radius: radius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius), radius: radius, startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

private struct BottomRoundedRectangle: Shape {
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius), radius: radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius), radius: radius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        path.closeSubpath()
        
        return path
    }
}


struct CitiesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CitiesView(countryName: "USA", cities: ["Atlanta", "Boston", "Dallas", "Houston"], initialCity: "Atlanta")
                .preferredColorScheme(.dark)
        }
    }
}
