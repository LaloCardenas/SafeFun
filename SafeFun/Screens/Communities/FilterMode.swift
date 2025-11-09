//
//  FilterMode.swift
//  SafeFun
//
//  Created by Santiago on 06/11/25.
//

import Foundation

private let blockedWords: Set<String> = [
    
    // Inglés
    "fuck",
    "fck",
    "f*ck",
    "shit",
    "sh*t",
    "bitch",
    "asshole",
    "cunt",
    "dick",
    "pussy",
    "bastard",
    "damn",
    "crap",
    "moron",
    "idiot",
    "stupid",

    // Español
    "mierda",
    "pendejo",
    "tontos",
    "pene",
    "armas",
    "idiota",
    "estúpido",
    "mames",
    "estupido",
    "cabron",
    "puta",
    "puto",
    "joder",
    "coño",
    "gilipollas",
    "idiota",
    "tonto",
    "imbecil",
    "carajo",
    "mamon",
    "culero",

    // Italiano
    "vaffanculo",
    "cazzo",
    "stronzo",
    "merda",
    "fanculo",
    "coglione",
    "puttana",
    "idiota",
    "stupido",
    "bastardo",
    "testa di cazzo",
    "pezzo di merda",
    "che palle",
    "troia",
    "fottiti",

    // Alemán
    "scheiße",
    "arschloch",
    "ficken",
    "wichser",
    "miststück",
    "verdammt",
    "hurensohn",
    "idiot",
    "blödmann",
    "trottel",
    "fick dich",
    "halts maul",
    "verpiss dich",
    "sau",
    "fotze",

    // Frances
    "merde",
    "putain",
    "connard",
    "conasse",
    "enculé",
    "salope",
    "bâtard",
    "ta gueule",
    "casse-toi",
    "foutre",
    "nique",
    "idiot",
    "stupide",
    "va te faire foutre",
    "fils de pute",
    
    //japones con texto normalizado
    "kuso",
    "shine",
    "baka",
    "aho",
    "urusai",
    "teme",
    "kisama",
    "yarou",
    "chikusho",
    "busu",
    "kuzu",
    "gomi",
    "onani",
    "kuso",
    "unko",

    // Chino (Pinyin) con texto normalizado
    "cào",
    "shabi",
    "bichi",
    "tā mā de",
    "gǔn",
    "qù sǐ",
    "bèndàn",
    "wangbadan",
    "sao",
    "jian",
    "cao ni ma",
    "nima",
    "gou",
    "sha bi",
    "erbi"
]



func isMessageObscene(text: String) -> Bool {

    let normalizedText = text.lowercased()
        .folding(options: .diacriticInsensitive, locale: .current)
    

    let words = normalizedText.components(separatedBy: .alphanumerics.inverted)

    for word in words {
        if blockedWords.contains(word) {
            return true
        }
    }
    
    return false
}
