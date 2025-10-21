//
//  NewsView.swift
//  SafeFun
//
//  Created by Lalo Cardenas on 19/10/25.
//

import SwiftUI

// Define el color de fondo personalizado (verde-limón)
// --- VISTA PRINCIPAL ---
struct NewsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        Text("Noticias")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        // --- BOTONES SUPERIORES ---
                        HStack(spacing: 12) {
                            BotonFiltro(texto: "Comunidad", icono: "person.2")
                            BotonFiltro(texto: "Selección (País)", icono: "list.bullet")
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        // --- BANNER PRINCIPAL ---
                        ZStack(alignment: .bottomLeading) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 180)
                            Text("Banner title")
                                .font(.title).fontWeight(.bold)
                                .foregroundColor(.black).padding(20)
                        }
                        .padding(.horizontal)
                        Divider()
                        // --- SECCIÓN GRUPOS (MODIFICADA) ---
                        VStack(alignment: .leading, spacing: 12) {
                            
                            // Navega a la vista general de Grupos (GruposView)
                            NavigationLink(destination: WCGroupsListView()) {
                                SectionHeader(titulo: "Grupos")
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    GrupoItem(letra: "A", colorFondo: .green)
                                    GrupoItem(letra: "B", colorFondo: .red)
                                    GrupoItem(letra: "C", colorFondo: .blue)
                                    GrupoItem(letra: "D", colorFondo: .orange)
                                    GrupoItem(letra: "E", colorFondo: .orange)
                                    GrupoItem(letra: "F", colorFondo: .orange)
                                    GrupoItem(letra: "G", colorFondo: .orange)
                                    GrupoItem(letra: "H", colorFondo: .orange)
                                    GrupoItem(letra: "I", colorFondo: .orange)
                                    GrupoItem(letra: "J", colorFondo: .orange)
                                    GrupoItem(letra: "K", colorFondo: .orange)
                                    GrupoItem(letra: "L", colorFondo: .orange)
                                }
                                .padding(.horizontal)
                            }
                        }
                        Divider()
                        // --- SECCIÓN CIUDADES ---
                        VStack(alignment: .leading, spacing: 12) {
                            NavigationLink(destination: CiudadesView()) {
                                SectionHeader(titulo: "EUA")
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    NavigationLink(destination: CiudadDetailView(ciudad: "New York")) {
                                        CiudadItem(ciudad: "New York", noticia: "Noticia 1", colorFondo: .purple)
                                    }
                                    NavigationLink(destination: CiudadDetailView(ciudad: "Miami")) {
                                        CiudadItem(ciudad: "Miami", noticia: "Noticia 1", colorFondo: .teal)
                                    }
                                    NavigationLink(destination: CiudadDetailView(ciudad: "San Franc")) {
                                        CiudadItem(ciudad: "San Franc", noticia: "Noticia 1", colorFondo: .brown)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        Divider()
                        // --- SECCIÓN CIUDADES CANADA---
                        VStack(alignment: .leading, spacing: 12) {
                            NavigationLink(destination: CiudadesView()) {
                                SectionHeader(titulo: "MEXICO")
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    NavigationLink(destination: CiudadDetailView(ciudad: "New York")) {
                                        CiudadItem(ciudad: "New York", noticia: "Noticia 1", colorFondo: .purple)
                                    }
                                    NavigationLink(destination: CiudadDetailView(ciudad: "Miami")) {
                                        CiudadItem(ciudad: "Miami", noticia: "Noticia 1", colorFondo: .teal)
                                    }
                                    NavigationLink(destination: CiudadDetailView(ciudad: "San Franc")) {
                                        CiudadItem(ciudad: "San Franc", noticia: "Noticia 1", colorFondo: .brown)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        Divider()
                        // --- SECCIÓN CIUDADES ---
                        VStack(alignment: .leading, spacing: 12) {
                            NavigationLink(destination: CiudadesView()) {
                                SectionHeader(titulo: "CANADA")
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    NavigationLink(destination: CiudadDetailView(ciudad: "New York")) {
                                        CiudadItem(ciudad: "Vancouver", noticia: "Noticia 1", colorFondo: .purple)
                                    }
                                    NavigationLink(destination: CiudadDetailView(ciudad: "Miami")) {
                                        CiudadItem(ciudad: "Toronto", noticia: "Noticia 1", colorFondo: .teal)
                                    }
                                    
                                    .padding(.horizontal)
                                }
                            }
                            
                        }
                        .padding(.top)
                        .padding(.bottom)
                    }
                    
                }
                .navigationBarHidden(true)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    
    // --- VISTAS DE AYUDA (Componentes Reutilizables) ---
    
    struct BotonFiltro: View {
        var texto: String
        var icono: String
        var body: some View {
            Button(action: {}) {
                Label(texto, systemImage: icono)
                    .font(.callout).fontWeight(.medium)
                    .foregroundColor(.black.opacity(0.8))
                    .padding(.vertical, 8).padding(.horizontal, 12)
                    .background(Color.white.opacity(0.7))
                    .clipShape(Capsule())
            }
        }
    }
    
    struct SectionHeader: View {
        var titulo: String
        var body: some View {
            HStack {
                Text(titulo).font(.title2).fontWeight(.bold)
                Spacer()
                Image(systemName: "chevron.right").font(.callout).foregroundColor(.gray)
            }
            .padding(.horizontal)
        }
    }
    
    struct GrupoItem: View {
        var letra: String
        var colorFondo: Color
        var body: some View {
            VStack(spacing: 8) {
                ZStack {
                    Circle().fill(colorFondo.opacity(0.3))
                        .frame(width: 70, height: 70)
                }
                Text(letra).font(.caption).fontWeight(.medium)
            }
        }
    }
    
    struct CiudadItem: View {
        var ciudad: String
        var noticia: String
        var colorFondo: Color
        let tamanoImagen: CGFloat = 140
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorFondo.opacity(0.3))
                        .frame(width: tamanoImagen, height: tamanoImagen)
                }
                Text(ciudad).font(.callout).foregroundColor(.secondary)
                Text(noticia).font(.headline).fontWeight(.medium)
            }
            .frame(width: tamanoImagen)
        }
    }
    
    struct CiudadDetailView: View {
        var ciudad: String
        var body: some View {
            ZStack {
                BackgroundView()
                VStack {
                    Text("Detalles de la noticia para")
                        .font(.title2)
                    Text(ciudad)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Text("Aquí iría todo el contenido de la noticia seleccionada...")
                        .padding()
                    Spacer()
                }
            }
            .navigationTitle(ciudad)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
    struct NewsView_Previews: PreviewProvider {
        static var previews: some View {
            NewsView()
        }
    }
}
