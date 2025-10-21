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
    // Group A
    static let southAfrica = Team(name: "South Africa", initials: "RSA", flag: "🇿🇦")
    static let usa = Team(name: "USA", initials: "USA", flag: "🇺🇸")
    static let newCaledonia = Team(name: "New Caledonia", initials: "NCL", flag: "🇳🇨")
    static let france = Team(name: "France", initials: "FRA", flag: "🇫🇷")

    // Group B
    static let england = Team(name: "England", initials: "ENG", flag: "🏴󠁧󠁢󠁥󠁮󠁧󠁿")
    static let japan = Team(name: "Japan", initials: "JPN", flag: "🇯🇵")
    static let senegal = Team(name: "Senegal", initials: "SEN", flag: "🇸🇳")
    static let costaRica = Team(name: "Costa Rica", initials: "CRC", flag: "🇨🇷")
        
    // Group C
    static let argentina = Team(name: "Argentina", initials: "ARG", flag: "🇦🇷")
    static let poland = Team(name: "Poland", initials: "POL", flag: "🇵🇱")
    static let mexico = Team(name: "Mexico", initials: "MEX", flag: "🇲🇽")
    static let australia = Team(name: "Australia", initials: "AUS", flag: "🇦🇺")
        
    // Group D
    static let brazil = Team(name: "Brazil", initials: "BRA", flag: "🇧🇷")
    static let morocco = Team(name: "Morocco", initials: "MAR", flag: "🇲🇦")
    static let denmark = Team(name: "Denmark", initials: "DEN", flag: "🇩🇰")
    static let saudiArabia = Team(name: "Saudi Arabia", initials: "KSA", flag: "🇸🇦")
    
    // Group E
    static let germany = Team(name: "Germany", initials: "GER", flag: "🇩🇪")
    static let spain = Team(name: "Spain", initials: "ESP", flag: "🇪🇸")
    static let southKorea = Team(name: "South Korea", initials: "KOR", flag: "🇰🇷")
    static let newZealand = Team(name: "New Zealand", initials: "NZL", flag: "🇳🇿")
    
    // Group F
    static let belgium = Team(name: "Belgium", initials: "BEL", flag: "🇧🇪")
    static let croatia = Team(name: "Croatia", initials: "CRO", flag: "🇭🇷")
    static let canada = Team(name: "Canada", initials: "CAN", flag: "🇨🇦")
    static let ghana = Team(name: "Ghana", initials: "GHA", flag: "🇬🇭")
    
    // Group G
    static let netherlands = Team(name: "Netherlands", initials: "NED", flag: "🇳🇱")
    static let uruguay = Team(name: "Uruguay", initials: "URU", flag: "🇺🇾")
    static let serbia = Team(name: "Serbia", initials: "SRB", flag: "🇷🇸")
    static let cameroon = Team(name: "Cameroon", initials: "CMR", flag: "🇨🇲")
    
    // Group H
    static let portugal = Team(name: "Portugal", initials: "POR", flag: "🇵🇹")
    static let colombia = Team(name: "Colombia", initials: "COL", flag: "🇨🇴")
    static let switzerland = Team(name: "Switzerland", initials: "SUI", flag: "🇨🇭")
    static let iran = Team(name: "Iran", initials: "IRN", flag: "🇮🇷")
    
    // Group I
    static let italy = Team(name: "Italy", initials: "ITA", flag: "🇮🇹")
    static let sweden = Team(name: "Sweden", initials: "SWE", flag: "🇸🇪")
    static let peru = Team(name: "Peru", initials: "PER", flag: "🇵🇪")
    static let algeria = Team(name: "Algeria", initials: "ALG", flag: "🇩🇿")
    
    // Group J
    static let nigeria = Team(name: "Nigeria", initials: "NGA", flag: "🇳🇬")
    static let chile = Team(name: "Chile", initials: "CHI", flag: "🇨🇱")
    static let ukraine = Team(name: "Ukraine", initials: "UKR", flag: "🇺🇦")
    static let qatar = Team(name: "Qatar", initials: "QAT", flag: "🇶🇦")
    
    // Group K
    static let egypt = Team(name: "Egypt", initials: "EGY", flag: "🇪🇬")
    static let scotland = Team(name: "Scotland", initials: "SCO", flag: "🏴󠁧󠁢󠁳󠁣󠁴󠁿")
    static let norway = Team(name: "Norway", initials: "NOR", flag: "🇳🇴")
    static let panama = Team(name: "Panama", initials: "PAN", flag: "🇵🇦")
    
    // Group L
    static let ecuador = Team(name: "Ecuador", initials: "ECU", flag: "🇪🇨")
    static let tunisia = Team(name: "Tunisia", initials: "TUN", flag: "🇹🇳")
    static let wales = Team(name: "Wales", initials: "WAL", flag: "🏴󠁧󠁢󠁷󠁬󠁳󠁿")
    static let jamaica = Team(name: "Jamaica", initials: "JAM", flag: "🇯🇲")
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
                GroupStanding(team: .england, mp: 2, w: 1, d: 1, l: 0, gf: 4, ga: 2, pts: 4, last5: [true, nil]),
                GroupStanding(team: .japan, mp: 2, w: 1, d: 1, l: 0, gf: 3, ga: 1, pts: 4, last5: [true, nil]),
                GroupStanding(team: .senegal, mp: 2, w: 1, d: 0, l: 1, gf: 3, ga: 3, pts: 3, last5: [false, true]),
                GroupStanding(team: .costaRica, mp: 2, w: 0, d: 0, l: 2, gf: 0, ga: 4, pts: 0, last5: [false, false])
            ],
            matchdays: [
                Matchday(name: "Matchday 1", matches: [
                    Match(team1: .england, score1: 3, team2: .senegal, score2: 1, date: "Jul 5", isFuture: false),
                    Match(team1: .japan, score1: 2, team2: .costaRica, score2: 0, date: "Jul 5", isFuture: false)
                ]),
                Matchday(name: "Matchday 2", matches: [
                    Match(team1: .england, score1: 1, team2: .japan, score2: 1, date: "Jul 9", isFuture: false),
                    Match(team1: .senegal, score1: 2, team2: .costaRica, score2: 0, date: "Jul 9", isFuture: false)
                ]),
                Matchday(name: "Matchday 3", matches: [
                    Match(team1: .england, score1: nil, team2: .costaRica, score2: nil, date: "Jul 12", isFuture: true),
                    Match(team1: .senegal, score1: nil, team2: .japan, score2: nil, date: "Jul 12", isFuture: true)
                ])
            ]
        )
        
        static let sampleWCGroupC = WCGroup(
            name: "Group C",
            standings: [
                GroupStanding(team: .argentina, mp: 2, w: 2, d: 0, l: 0, gf: 3, ga: 0, pts: 6, last5: [true, true]),
                GroupStanding(team: .poland, mp: 2, w: 1, d: 0, l: 1, gf: 2, ga: 3, pts: 3, last5: [false, true]),
                GroupStanding(team: .mexico, mp: 2, w: 0, d: 1, l: 1, gf: 1, ga: 2, pts: 1, last5: [nil, false]),
                GroupStanding(team: .australia, mp: 2, w: 0, d: 1, l: 1, gf: 2, ga: 3, pts: 1, last5: [nil, false])
            ],
            matchdays: [
                Matchday(name: "Matchday 1", matches: [
                    Match(team1: .argentina, score1: 2, team2: .poland, score2: 0, date: "Jul 6", isFuture: false),
                    Match(team1: .mexico, score1: 1, team2: .australia, score2: 1, date: "Jul 6", isFuture: false)
                ]),
                Matchday(name: "Matchday 2", matches: [
                    Match(team1: .argentina, score1: 1, team2: .mexico, score2: 0, date: "Jul 10", isFuture: false),
                    Match(team1: .poland, score1: 2, team2: .australia, score2: 1, date: "Jul 10", isFuture: false)
                ]),
                Matchday(name: "Matchday 3", matches: [
                    Match(team1: .argentina, score1: nil, team2: .australia, score2: nil, date: "Jul 13", isFuture: true),
                    Match(team1: .mexico, score1: nil, team2: .poland, score2: nil, date: "Jul 13", isFuture: true)
                ])
            ]
        )
        
        static let sampleWCGroupD = WCGroup(
            name: "Group D",
            standings: [
                GroupStanding(team: .brazil, mp: 2, w: 2, d: 0, l: 0, gf: 6, ga: 0, pts: 6, last5: [true, true]),
                GroupStanding(team: .morocco, mp: 2, w: 1, d: 1, l: 0, gf: 3, ga: 2, pts: 4, last5: [nil, true]),
                GroupStanding(team: .denmark, mp: 2, w: 0, d: 1, l: 1, gf: 1, ga: 3, pts: 1, last5: [nil, false]),
                GroupStanding(team: .saudiArabia, mp: 2, w: 0, d: 0, l: 2, gf: 1, ga: 6, pts: 0, last5: [false, false])
            ],
            matchdays: [
                Matchday(name: "Matchday 1", matches: [
                    Match(team1: .brazil, score1: 4, team2: .saudiArabia, score2: 0, date: "Jul 6", isFuture: false),
                    Match(team1: .denmark, score1: 1, team2: .morocco, score2: 1, date: "Jul 6", isFuture: false)
                ]),
                Matchday(name: "Matchday 2", matches: [
                    Match(team1: .brazil, score1: 2, team2: .denmark, score2: 0, date: "Jul 10", isFuture: false),
                    Match(team1: .morocco, score1: 2, team2: .saudiArabia, score2: 1, date: "Jul 10", isFuture: false)
                ]),
                Matchday(name: "Matchday 3", matches: [
                    Match(team1: .brazil, score1: nil, team2: .morocco, score2: nil, date: "Jul 13", isFuture: true),
                    Match(team1: .denmark, score1: nil, team2: .saudiArabia, score2: nil, date: "Jul 13", isFuture: true)
                ])
            ]
        )
        
        static let sampleWCGroupE = WCGroup(
            name: "Group E",
            standings: [
                GroupStanding(team: .germany, mp: 2, w: 1, d: 1, l: 0, gf: 5, ga: 1, pts: 4, last5: [nil, true]),
                GroupStanding(team: .spain, mp: 2, w: 1, d: 1, l: 0, gf: 3, ga: 1, pts: 4, last5: [nil, true]),
                GroupStanding(team: .southKorea, mp: 2, w: 1, d: 0, l: 1, gf: 3, ga: 2, pts: 3, last5: [true, false]),
                GroupStanding(team: .newZealand, mp: 2, w: 0, d: 0, l: 2, gf: 0, ga: 7, pts: 0, last5: [false, false])
            ],
            matchdays: [
                Matchday(name: "Matchday 1", matches: [
                    Match(team1: .germany, score1: 1, team2: .spain, score2: 1, date: "Jul 7", isFuture: false),
                    Match(team1: .southKorea, score1: 3, team2: .newZealand, score2: 0, date: "Jul 7", isFuture: false)
                ]),
                Matchday(name: "Matchday 2", matches: [
                    Match(team1: .germany, score1: 4, team2: .newZealand, score2: 0, date: "Jul 11", isFuture: false),
                    Match(team1: .spain, score1: 2, team2: .southKorea, score2: 0, date: "Jul 11", isFuture: false)
                ]),
                Matchday(name: "Matchday 3", matches: [
                    Match(team1: .germany, score1: nil, team2: .southKorea, score2: nil, date: "Jul 14", isFuture: true),
                    Match(team1: .spain, score1: nil, team2: .newZealand, score2: nil, date: "Jul 14", isFuture: true)
                ])
            ]
        )
        
        static let sampleWCGroupF = WCGroup(
            name: "Group F",
            standings: [
                GroupStanding(team: .belgium, mp: 2, w: 1, d: 1, l: 0, gf: 3, ga: 1, pts: 4, last5: [true, nil]),
                GroupStanding(team: .croatia, mp: 2, w: 1, d: 1, l: 0, gf: 2, ga: 1, pts: 4, last5: [true, nil]),
                GroupStanding(team: .canada, mp: 2, w: 1, d: 0, l: 1, gf: 2, ga: 3, pts: 3, last5: [false, true]),
                GroupStanding(team: .ghana, mp: 2, w: 0, d: 0, l: 2, gf: 1, ga: 3, pts: 0, last5: [false, false])
            ],
            matchdays: [
                Matchday(name: "Matchday 1", matches: [
                    Match(team1: .belgium, score1: 2, team2: .canada, score2: 0, date: "Jul 7", isFuture: false),
                    Match(team1: .croatia, score1: 1, team2: .ghana, score2: 0, date: "Jul 7", isFuture: false)
                ]),
                Matchday(name: "Matchday 2", matches: [
                    Match(team1: .belgium, score1: 1, team2: .croatia, score2: 1, date: "Jul 11", isFuture: false),
                    Match(team1: .canada, score1: 2, team2: .ghana, score2: 1, date: "Jul 11", isFuture: false)
                ]),
                Matchday(name: "Matchday 3", matches: [
                    Match(team1: .belgium, score1: nil, team2: .ghana, score2: nil, date: "Jul 14", isFuture: true),
                    Match(team1: .canada, score1: nil, team2: .croatia, score2: nil, date: "Jul 14", isFuture: true)
                ])
            ]
        )
        
        static let sampleWCGroupG = WCGroup(
            name: "Group G",
            standings: [
                GroupStanding(team: .netherlands, mp: 2, w: 2, d: 0, l: 0, gf: 5, ga: 1, pts: 6, last5: [true, true]),
                GroupStanding(team: .uruguay, mp: 2, w: 1, d: 1, l: 0, gf: 1, ga: 0, pts: 4, last5: [true, nil]),
                GroupStanding(team: .serbia, mp: 2, w: 0, d: 1, l: 1, gf: 0, ga: 2, pts: 1, last5: [false, nil]),
                GroupStanding(team: .cameroon, mp: 2, w: 0, d: 0, l: 2, gf: 1, ga: 4, pts: 0, last5: [false, false])
            ],
            matchdays: [
                Matchday(name: "Matchday 1", matches: [
                    Match(team1: .netherlands, score1: 2, team2: .serbia, score2: 0, date: "Jul 8", isFuture: false),
                    Match(team1: .uruguay, score1: 1, team2: .cameroon, score2: 0, date: "Jul 8", isFuture: false)
                ]),
                Matchday(name: "Matchday 2", matches: [
                    Match(team1: .netherlands, score1: 3, team2: .cameroon, score2: 1, date: "Jul 12", isFuture: false),
                    Match(team1: .uruguay, score1: 0, team2: .serbia, score2: 0, date: "Jul 12", isFuture: false)
                ]),
                Matchday(name: "Matchday 3", matches: [
                    Match(team1: .netherlands, score1: nil, team2: .uruguay, score2: nil, date: "Jul 15", isFuture: true),
                    Match(team1: .serbia, score1: nil, team2: .cameroon, score2: nil, date: "Jul 15", isFuture: true)
                ])
            ]
        )
        
        static let sampleWCGroupH = WCGroup(
            name: "Group H",
            standings: [
                GroupStanding(team: .portugal, mp: 2, w: 1, d: 1, l: 0, gf: 5, ga: 2, pts: 4, last5: [true, nil]),
                GroupStanding(team: .colombia, mp: 2, w: 1, d: 1, l: 0, gf: 2, ga: 1, pts: 4, last5: [nil, true]),
                GroupStanding(team: .switzerland, mp: 2, w: 0, d: 2, l: 0, gf: 3, ga: 3, pts: 2, last5: [nil, nil]),
                GroupStanding(team: .iran, mp: 2, w: 0, d: 0, l: 2, gf: 0, ga: 4, pts: 0, last5: [false, false])
            ],
            matchdays: [
                Matchday(name: "Matchday 1", matches: [
                    Match(team1: .portugal, score1: 3, team2: .iran, score2: 0, date: "Jul 8", isFuture: false),
                    Match(team1: .switzerland, score1: 1, team2: .colombia, score2: 1, date: "Jul 8", isFuture: false)
                ]),
                Matchday(name: "Matchday 2", matches: [
                    Match(team1: .portugal, score1: 2, team2: .switzerland, score2: 2, date: "Jul 12", isFuture: false),
                    Match(team1: .colombia, score1: 1, team2: .iran, score2: 0, date: "Jul 12", isFuture: false)
                ]),
                Matchday(name: "Matchday 3", matches: [
                    Match(team1: .portugal, score1: nil, team2: .colombia, score2: nil, date: "Jul 15", isFuture: true),
                    Match(team1: .switzerland, score1: nil, team2: .iran, score2: nil, date: "Jul 15", isFuture: true)
                ])
            ]
        )
        
        static let sampleWCGroupI = WCGroup(
            name: "Group I",
            standings: [
                GroupStanding(team: .italy, mp: 2, w: 2, d: 0, l: 0, gf: 3, ga: 0, pts: 6, last5: [true, true]),
                GroupStanding(team: .sweden, mp: 2, w: 1, d: 0, l: 1, gf: 1, ga: 1, pts: 3, last5: [true, false]),
                GroupStanding(team: .peru, mp: 2, w: 1, d: 0, l: 1, gf: 2, ga: 2, pts: 3, last5: [false, true]),
                GroupStanding(team: .algeria, mp: 2, w: 0, d: 0, l: 2, gf: 1, ga: 4, pts: 0, last5: [false, false])
            ],
            matchdays: [
                Matchday(name: "Matchday 1", matches: [
                    Match(team1: .italy, score1: 2, team2: .algeria, score2: 0, date: "Jul 9", isFuture: false),
                    Match(team1: .sweden, score1: 1, team2: .peru, score2: 0, date: "Jul 9", isFuture: false)
                ]),
                Matchday(name: "Matchday 2", matches: [
                    Match(team1: .italy, score1: 1, team2: .sweden, score2: 0, date: "Jul 13", isFuture: false),
                    Match(team1: .peru, score1: 2, team2: .algeria, score2: 1, date: "Jul 13", isFuture: false)
                ]),
                Matchday(name: "Matchday 3", matches: [
                    Match(team1: .italy, score1: nil, team2: .peru, score2: nil, date: "Jul 16", isFuture: true),
                    Match(team1: .sweden, score1: nil, team2: .algeria, score2: nil, date: "Jul 16", isFuture: true)
                ])
            ]
        )
        
        static let sampleWCGroupJ = WCGroup(
            name: "Group J",
            standings: [
                GroupStanding(team: .nigeria, mp: 2, w: 1, d: 1, l: 0, gf: 3, ga: 2, pts: 4, last5: [true, nil]),
                GroupStanding(team: .chile, mp: 2, w: 1, d: 1, l: 0, gf: 4, ga: 1, pts: 4, last5: [true, nil]),
                GroupStanding(team: .ukraine, mp: 2, w: 1, d: 0, l: 1, gf: 3, ga: 2, pts: 3, last5: [false, true]),
                GroupStanding(team: .qatar, mp: 2, w: 0, d: 0, l: 2, gf: 0, ga: 5, pts: 0, last5: [false, false])
            ],
            matchdays: [
                Matchday(name: "Matchday 1", matches: [
                    Match(team1: .nigeria, score1: 2, team2: .ukraine, score2: 1, date: "Jul 9", isFuture: false),
                    Match(team1: .chile, score1: 3, team2: .qatar, score2: 0, date: "Jul 9", isFuture: false)
                ]),
                Matchday(name: "Matchday 2", matches: [
                    Match(team1: .nigeria, score1: 1, team2: .chile, score2: 1, date: "Jul 13", isFuture: false),
                    Match(team1: .ukraine, score1: 2, team2: .qatar, score2: 0, date: "Jul 13", isFuture: false)
                ]),
                Matchday(name: "Matchday 3", matches: [
                    Match(team1: .nigeria, score1: nil, team2: .qatar, score2: nil, date: "Jul 16", isFuture: true),
                    Match(team1: .chile, score1: nil, team2: .ukraine, score2: nil, date: "Jul 16", isFuture: true)
                ])
            ]
        )
        
        static let sampleWCGroupK = WCGroup(
            name: "Group K",
            standings: [
                GroupStanding(team: .egypt, mp: 2, w: 1, d: 1, l: 0, gf: 3, ga: 2, pts: 4, last5: [true, nil]),
                GroupStanding(team: .scotland, mp: 2, w: 1, d: 1, l: 0, gf: 4, ga: 2, pts: 4, last5: [true, nil]),
                GroupStanding(team: .norway, mp: 2, w: 1, d: 0, l: 1, gf: 3, ga: 2, pts: 3, last5: [false, true]),
                GroupStanding(team: .panama, mp: 2, w: 0, d: 0, l: 2, gf: 1, ga: 5, pts: 0, last5: [false, false])
            ],
            matchdays: [
                Matchday(name: "Matchday 1", matches: [
                    Match(team1: .egypt, score1: 1, team2: .norway, score2: 0, date: "Jul 10", isFuture: false),
                    Match(team1: .scotland, score1: 2, team2: .panama, score2: 0, date: "Jul 10", isFuture: false)
                ]),
                Matchday(name: "Matchday 2", matches: [
                    Match(team1: .egypt, score1: 2, team2: .scotland, score2: 2, date: "Jul 14", isFuture: false),
                    Match(team1: .norway, score1: 3, team2: .panama, score2: 1, date: "Jul 14", isFuture: false)
                ]),
                Matchday(name: "Matchday 3", matches: [
                    Match(team1: .egypt, score1: nil, team2: .panama, score2: nil, date: "Jul 17", isFuture: true),
                    Match(team1: .norway, score1: nil, team2: .scotland, score2: nil, date: "Jul 17", isFuture: true)
                ])
            ]
        )
        
        static let sampleWCGroupL = WCGroup(
            name: "Group L",
            standings: [
                GroupStanding(team: .ecuador, mp: 2, w: 2, d: 0, l: 0, gf: 3, ga: 0, pts: 6, last5: [true, true]),
                GroupStanding(team: .tunisia, mp: 2, w: 1, d: 0, l: 1, gf: 2, ga: 3, pts: 3, last5: [false, true]),
                GroupStanding(team: .wales, mp: 2, w: 0, d: 1, l: 1, gf: 1, ga: 2, pts: 1, last5: [nil, false]),
                GroupStanding(team: .jamaica, mp: 2, w: 0, d: 1, l: 1, gf: 2, ga: 3, pts: 1, last5: [nil, false])
            ],
            matchdays: [
                Matchday(name: "Matchday 1", matches: [
                    Match(team1: .ecuador, score1: 2, team2: .tunisia, score2: 0, date: "Jul 10", isFuture: false),
                    Match(team1: .wales, score1: 1, team2: .jamaica, score2: 1, date: "Jul 10", isFuture: false)
                ]),
                Matchday(name: "Matchday 2", matches: [
                    Match(team1: .ecuador, score1: 1, team2: .wales, score2: 0, date: "Jul 14", isFuture: false),
                    Match(team1: .tunisia, score1: 2, team2: .jamaica, score2: 1, date: "Jul 14", isFuture: false)
                ]),
                Matchday(name: "Matchday 3", matches: [
                    Match(team1: .ecuador, score1: nil, team2: .jamaica, score2: nil, date: "Jul 17", isFuture: true),
                    Match(team1: .wales, score1: nil, team2: .tunisia, score2: nil, date: "Jul 17", isFuture: true)
                ])
            ]
        )
}
