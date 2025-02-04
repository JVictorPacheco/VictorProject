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
    
    var life: Int {
        return stats.first { $0.stat.name == "hp"}?.base_stat ?? 0
    }
    
    var speed: Int {
        return stats.first { $0.stat.name == "speed"}?.base_stat ?? 0
    }
    
    var specialAttack: Int {
        return stats.first { $0.stat.name == "special-attack"}?.base_stat ?? 0
    }
    
    var specialDefense: Int {
        return stats.first { $0.stat.name == "special-defense"}?.base_stat ?? 0
    }
    
}

enum PokemonType: String, CaseIterable {
    case normal = "normal"
    case fire = "fire"
    case water = "water"
    case electric = "electric"
    case grass = "grass"
    case ice = "ice"
    case fighting = "fighting"
    case poison = "poison"
    case ground = "ground"
    case flying = "flying"
    case psychic = "psychic"
    case bug = "bug"
    case rock = "rock"
    case ghost = "ghost"
    case dragon = "dragon"
    case dark = "dark"
    case steel = "steel"
    case fairy = "fairy"
    
    func emoji() -> String {
        switch self {
        case .normal: return "🔘"
        case .fire: return "🔥"
        case .water: return "💧"
        case .electric: return "⚡️"
        case .grass: return "🌿"
        case .ice: return "❄️"
        case .fighting: return "🥊"
        case .poison: return "☠️"
        case .ground: return "🏜"
        case .flying: return "🕊"
        case .psychic: return "🔮"
        case .bug: return "🐛"
        case .rock: return "🪨"
        case .ghost: return "👻"
        case .dragon: return "🐉"
        case .dark: return "🌑"
        case .steel: return "🔩"
        case .fairy: return "🧚"
        }
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
    let latest: String
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


struct PokemonSpecies: Decodable {
    let evolutionChain: EvolutionChainURL
    
    enum CodingKeys: String, CodingKey {
        case evolutionChain = "evolution_chain"
    }
}

struct EvolutionChainURL: Decodable {
    let url: String
}

struct EvolutionChain: Decodable {
    let chain: EvolutionStep
}

struct EvolutionStep: Decodable {
    let species: Species
    let evolvesTo: [EvolutionStep]
    
    enum CodingKeys: String, CodingKey {
        case species
        case evolvesTo = "evolves_to"
    }
}

struct EvolutionData {
    let name: String
    let imageURL: String
}

extension Pokemon {
    var typeEmojis: String {
        let emojis = types.compactMap { PokemonType(rawValue: $0.type.name)?.emoji() }
        return emojis.joined(separator: " ") // Exemplo: "🔥 🕊" para Charizard
    }
}
