//
//  Pokemon.swift
//  VictorProject
//
//  Created by Joao Pacheco on 19/01/25.
//

import UIKit

struct Pokemon: Decodable {
    let id: Int
    let name: String
    let sprites: Sprites
    let types: [TypeSlot]
    let height: Int
    let weight: Int
    let abilities: [AbilitySlot]
    let cries: Cries
    let stats: [Stat]
    
    var attack: Int {
        return stats.first { $0.stat.name == "attack"}?.base_stat ?? 0
    }
    
    var defense: Int {
        return stats.first { $0.stat.name == "defense"}?.base_stat ?? 0
    }
}

struct Stat: Decodable {
    let base_stat: Int
    let stat: StatInfo
    
    //    enum CondingKeys: String, CodingKey {
    //        case baseStat = "base_stat"
    //        case stat
    //    }
}

struct StatInfo: Decodable {
    let name: String
    
}

struct Sprites: Codable {
    let frontDefault: String
    let other: OtherSprites?
    
    
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case other
    }
}

struct OtherSprites: Codable {
    let officeArtwork: OfficeArtwork?
    
    enum CodingKeys: String, CodingKey {
        case officeArtwork = "official-artwork"
    }
}

struct OfficeArtwork: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// MARK: - Species
struct Species: Codable {
    let name: String
    let url: String
}

// MARK: - Cries
struct Cries: Codable {
    let latest, legacy: String
}

struct TypeSlot: Codable {
    let slot: Int
    let type: TypeDetail
}

struct TypeDetail: Codable {
    let name: String
    let url: String
}


struct AbilitySlot: Codable {
    let slot: Int
    let isHidden: Bool
    let ability: AbilityDetail
    
    enum CodingKeys: String, CodingKey {
        case slot
        case isHidden = "is_hidden"
        case ability
    }
}

struct AbilityDetail: Codable {
    let name: String
    let url: String
}
