//
//  WCGroupModels.swift
//  SafeFun
//
//  Created by Facultad de Contaduría y Administración on 20/10/25.
//

import Foundation

// --- 1. DATA MODELS ---

struct Team: Identifiable {
    let id = UUID()
    let name: String
    let initials: String
    let flag: String
}

struct GroupStanding: Identifiable {
    let id = UUID()
    let team: Team
    var mp: Int
    var w: Int
    var d: Int
    var l: Int
    var gf: Int
    var ga: Int
    var gd: Int { gf - ga }
    var pts: Int
    var last5: [Bool?]
}

struct Match: Identifiable {
    let id = UUID()
    let team1: Team
    let score1: Int?
    let team2: Team
    let score2: Int?
    let date: String
    let isFuture: Bool
}

// Una "Jornada" que contiene una lista de partidos
struct Matchday: Identifiable {
    let id = UUID()
    let name: String // Ej: "Matchday 1"
    let matches: [Match]
}

// WCGroup ahora tiene una lista de Matchdays
struct WCGroup: Identifiable {
    let id = UUID()
    let name: String
    var standings: [GroupStanding]
    var matchdays: [Matchday]
}

// --- 2. SAMPLE DATA ---
extension Team {
    static let southAfrica = Team(name: "South Africa U-20", initials: "RSA", flag: "🇿🇦")
    static let usa = Team(name: "USA U-20", initials: "USA", flag: "🇺🇸")
    static let newCaledonia = Team(name: "New Caledonia U-20", initials: "NCL", flag: "🇳🇨")
    static let france = Team(name: "France U-20", initials: "FRA", flag: "🇫🇷")
    static let germany = Team(name: "Germany", initials: "GER", flag: "🇩🇪")
    static let brazil = Team(name: "Brazil", initials: "BRA", flag: "🇧🇷")
    static let argentina = Team(name: "Argentina", initials: "ARG", flag: "🇦🇷")
    static let italy = Team(name: "Italy", initials: "ITA", flag: "🇮🇹")
}

extension WCGroup {
    static let sampleWCGroupA = WCGroup(
        name: "Group A",
        standings: [
            GroupStanding(team: .southAfrica, mp: 2, w: 2, d: 0, l: 0, gf: 5, ga: 1, pts: 6, last5: [true, true]),
            GroupStanding(team: .france, mp: 2, w: 1, d: 1, l: 0, gf: 7, ga: 1, pts: 4, last5: [true, nil]),
            GroupStanding(team: .usa, mp: 2, w: 0, d: 1, l: 1, gf: 2, ga: 3, pts: 1, last5: [nil, false]),
            GroupStanding(team: .newCaledonia, mp: 2, w: 0, d: 0, l: 2, gf: 0, ga: 9, pts: 0, last5: [false, false])
        ],
        matchdays: [
            Matchday(name: "Matchday 1", matches: [
                Match(team1: .southAfrica, score1: 2, team2: .usa, score2: 1, date: "Jul 5", isFuture: false),
                Match(team1: .newCaledonia, score1: 0, team2: .france, score2: 6, date: "Jul 5", isFuture: false)
            ]),
            Matchday(name: "Matchday 2", matches: [
                Match(team1: .southAfrica, score1: 3, team2: .newCaledonia, score2: 0, date: "Jul 9", isFuture: false),
                Match(team1: .usa, score1: 1, team2: .france, score2: 1, date: "Jul 9", isFuture: false)
            ]),
            Matchday(name: "Matchday 3", matches: [
                Match(team1: .southAfrica, score1: nil, team2: .france, score2: nil, date: "Jul 12", isFuture: true),
                Match(team1: .usa, score1: nil, team2: .newCaledonia, score2: nil, date: "Jul 12", isFuture: true)
            ])
        ]
    )

    static let sampleWCGroupB = WCGroup(
        name: "Group B",
        standings: [
            GroupStanding(team: .germany, mp: 6, w: 4, d: 2, l: 0, gf: 10, ga: 4, pts: 14, last5: [true, true, nil, true, true]),
            GroupStanding(team: .brazil, mp: 6, w: 3, d: 1, l: 2, gf: 7, ga: 6, pts: 10, last5: [true, false, nil, true, true]),
            GroupStanding(team: .argentina, mp: 6, w: 2, d: 1, l: 3, gf: 8, ga: 9, pts: 7, last5: [false, true, false, false, false]),
            GroupStanding(team: .italy, mp: 6, w: 1, d: 2, l: 3, gf: 5, ga: 11, pts: 5, last5: [false, false, true, false, false])
        ],
        matchdays: [
            Matchday(name: "Matchday 1", matches: [
                Match(team1: .germany, score1: 1, team2: .brazil, score2: 1, date: "Jul 6", isFuture: false),
                Match(team1: .argentina, score1: 2, team2: .italy, score2: 0, date: "Jul 6", isFuture: false)
            ]),
            Matchday(name: "Matchday 2", matches: [
                Match(team1: .germany, score1: nil, team2: .argentina, score2: nil, date: "Jul 13", isFuture: true),
                Match(team1: .brazil, score1: nil, team2: .italy, score2: nil, date: "Jul 13", isFuture: true)
            ])
        ]
    )
}
