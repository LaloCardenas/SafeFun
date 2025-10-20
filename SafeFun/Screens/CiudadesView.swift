//
//  CiudadesView.swift
//  SafeFun
//
//  Created by Facultad de Contaduría y Administración on 20/10/25.
//

import SwiftUI

// --- VISTA DE LISTA DE CIUDADES (EUA) ---

struct CiudadesView: View {
    // Lista de ciudades de ejemplo
    let cities = ["New York", "Miami", "Los Angeles", "Seattle", "Boston", "Dallas"]
    
    // Estado para la ciudad seleccionada
    @State private var selectedCity = "New York"
    
    var body: some View {
        ZStack {
            // Mantenemos el mismo color de fondo
            BackgroundView()
            VStack(alignment: .leading, spacing: 0) {
                // --- Scroll Horizontal de Ciudades (Chips) ---
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(cities, id: \.self) { city in
                            Button(action: {
                                withAnimation {
                                    selectedCity = city // Actualiza el estado
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
                .background(Color.white.opacity(0.5)) // Asegura que el fondo del scroll sea del color
                
                // --- Lista Vertical de Noticias ---
                List {
                    // Generamos 10 noticias de ejemplo para la ciudad seleccionada
                    ForEach(1...10, id: \.self) { _ in
                        // Usamos el nuevo componente ArticleRow
                        ArticleRow(city: selectedCity)
                    }
                    .listRowBackground(Color.white.opacity(0.5)) // Fondo de celda
                    .listRowSeparator(.hidden) // Ocultar separadores
                }
                .listStyle(.plain) // Estilo de lista
                .background(Color.white.opacity(0.5)) // Fondo de la lista
            }
        }
        .navigationTitle("EUA")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// --- COMPONENTE: CELDA DE ARTÍCULO ---

struct ArticleRow: View {
    var city: String // Para simular contenido filtrado
    
    var body: some View {
        HStack(spacing: 12) {
            // Placeholder para la imagen
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.purple.opacity(0.4)) // Color de ejemplo
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("El primer partido del Grupo D")
                        .font(.headline)
                    Spacer()
                    Text("07.01.26")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text("El partido de Kenia vs Curazo se llev...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}


// --- Vista Previa (Preview) ---
struct CiudadesView_Previews: PreviewProvider {
    static var previews: some View {
        CiudadesView()
    }
}
