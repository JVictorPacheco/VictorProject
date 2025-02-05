//
//  PokemonDetailViewModel.swift
//  VictorProject
//
//  Created by Joao Pacheco on 24/01/25.
//

import Foundation
import UIKit

final class PokemonDetailViewModel {
    private let pokemon: Pokemon
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    var pokemonId: Int? {
        pokemon.id
    }
    var pokemonName: String {
        pokemon.name.capitalized
    }
    
    var pokemonImage: String {
        pokemon.sprites.other?.officeArtwork?.frontDefault ?? pokemon.sprites.frontDefault
    }
    
    var pokemonTypes: String {
        pokemon.types.map {$0.type.name.capitalized}.joined(separator: ", ")
    }
    
    var pokemonAbilities: String {
        pokemon.abilities.filter { !$0.isHidden }
            .map { $0.ability.name.capitalized}
            .joined(separator: ", ")
    }
    
    var pokemonAudioUrl: String? {
        pokemon.cries.latest
    }
    
    var pokemonDetails: String {
        """
        Altura: \((Double(pokemon.height) / 10.0)) m
        Peso:   \((Double(pokemon.weight) / 10.0)) kg
        Tipos:  \(pokemon.typeEmojis)
        Habilidades: \(pokemonAbilities)
        """
    }
    
    var pokemonAtack: Int {
        pokemon.attack
    }

    var pokemonDefense: Int {
        pokemon.defense
    }

    var pokemonSpecialAtack: Int {
        pokemon.specialAttack
    }

    var pokemonSpecialDefense: Int {
        pokemon.specialDefense
    }

    var pokemonLife: Int {
        pokemon.life
    }

    var pokemonSpeed: Int {
        pokemon.speed
    }
    
    public func getEvolutions(for id: Int) {
        PokemonAPIService().fetchPokemonEvolutions(for: id) { evolutions in
            print("Linha de evolução:", evolutions.joined(separator: " → "))
        }
    }

}
