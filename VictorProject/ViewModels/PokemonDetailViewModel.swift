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
    
    var pokemonDetails: String {
        """
        Altura: \(pokemon.height / 10) m
        Peso:   \(pokemon.weight / 10) kg
        Tipos:  \(pokemonTypes)
        Habilidades: \(pokemonAbilities)
        """
    }
    
}
