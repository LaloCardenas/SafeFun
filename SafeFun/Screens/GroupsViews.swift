//
//  GruposView.swift
//  SafeFun
//
//  Created by Facultad de Contaduría y Administración on 20/10/25.
//

//
//  GruposView.swift
//  SafeFun
//
//  Created by Facultad de Contaduría y Administración on 20/10/25.
//

import SwiftUI

// --- Define custom colors ---
let darkGrayTable = Color(white: 0.25)
let slightlyLighterGray = Color(white: 0.3)

// --- Define la lista de grupos consumiendo los datos del archivo de Modelos ---
let allWCGroups: [WCGroup] = [.sampleWCGroupA, .sampleWCGroupB]


// --- 3. MAIN GROUPS LIST VIEW (MODIFICADA) ---

struct WCGroupsListView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                HStack(spacing: 12) {
                    BotonFiltro(texto: "Comunidad", icono: "person.2")
                    BotonFiltro(texto: "Selección (País)", icono: "list.bullet")
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)

                // --- INICIO DE LA MODIFICACIÓN ---
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(allWCGroups) { group in
                            NavigationLink(destination: WCGroupDetailView(group: group)) {
                                
                                HStack {
                                    Text(group.name)
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.black.opacity(0.8))
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.callout)
                                        .foregroundColor(.gray.opacity(0.7))
                                }
                                .padding()
                                .background(Color.white.opacity(0.5))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                // --- FIN DE LA MODIFICACIÓN ---
            }
        }
        .navigationTitle("Groups")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// --- 4. GROUP DETAIL VIEW ---

struct WCGroupDetailView: View {
    let group: WCGroup

    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Group stage")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    // --- Tabla de Posiciones ---
                    VStack(spacing: 0) {
                        
                        HStack {
                            Text("Club")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
                            Text("MP").frame(width: 30)
                            Text("W").frame(width: 30)
                            Text("D").frame(width: 30)
                            Text("L").frame(width: 30)
                            Text("GD").frame(width: 30)
                            Text("Pts").frame(width: 35)
                        }
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(darkGrayTable)
                        
                        ForEach(Array(group.standings.sorted(by: { $0.pts > $1.pts }).enumerated()), id: \.element.id) { index, standing in
                            WCGroupStandingRow(standing: standing, position: index + 1)
                        }
                    }
                    .background(darkGrayTable)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    
                    Divider().padding(.horizontal)
                    
                    // --- LISTA DE PARTIDOS ---
                    ForEach(group.matchdays) { matchday in
                        Text(matchday.name)
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .padding(.top, 10)
                        
                        ForEach(matchday.matches) { match in
                            MatchRow(match: match)
                        }
                    }
                }
                .padding(.vertical)
            }
        }
        .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// --- 5. HELPER COMPONENTS ---
// --- Fila de la Tabla de Posiciones ---
struct WCGroupStandingRow: View {
    let standing: GroupStanding
    let position: Int
    
    var rowColor: Color {
        return (position % 2 == 0) ? slightlyLighterGray : darkGrayTable
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 10) {
                Text("\(position)")
                    .frame(width: 15)
                
                Text(standing.team.flag)
                    .font(.system(size: 24))
                    .frame(width: 20, height: 20, alignment: .center)
                
                Text(standing.team.initials)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Text("\(standing.mp)").frame(width: 30)
            Text("\(standing.w)").frame(width: 30)
            Text("\(standing.d)").frame(width: 30)
            Text("\(standing.l)").frame(width: 30)
            Text("\(standing.gd)").frame(width: 30)
            Text("\(standing.pts)").frame(width: 35)
        }
        .font(.subheadline.bold())
        .foregroundColor(.white)
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(rowColor)
    }
}


// --- Fila de Partido ---
struct MatchRow: View {
    let match: Match
    
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Text(match.team1.flag)
                    .font(.system(size: 30))
                
                Text(match.team1.initials)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Spacer()
            
            if match.isFuture {
                Text(match.date)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            } else {
                Text("\(match.score1 ?? 0) - \(match.score2 ?? 0)")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Text(match.team2.initials)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(match.team2.flag)
                    .font(.system(size: 30))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.5))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}


// --- 6. PREVIEWS ---
struct WCGroupsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WCGroupsListView()
        }
    }
}

struct WCGroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WCGroupDetailView(group: .sampleWCGroupA)
    }
}
