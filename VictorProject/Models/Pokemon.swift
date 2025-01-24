//
//  Pokemon.swift
//  VictorProject
//
//  Created by Joao Pacheco on 19/01/25.
//

import UIKit

struct Pokemon: Codable {
    let name: String
    let sprites: Sprites
    let types: [PokemonType]
    let height: Int
    let weight: Int
    let abilities: [String]
}

struct Sprites: Codable {
    let frontDefault: String
    let other: OtherSprites
    
    
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case other
    }
}

struct OtherSprites: Codable {
    let officeArtwork: OfficeArtwork
    
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


struct PokemonDetail: Codable {
    let int: Int
    let name: String
    let sprites: Sprites
}

struct PokemonType: Codable {
    let type: TypeDetail
}


struct TypeDetail: Codable {
    let name: String
}

struct PokemonAbility: Codable {
    let ability: AbilityDetail
}

struct AbilityDetail: Codable {
    let name: String
}
