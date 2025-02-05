import Foundation

protocol PokemonService {
    func fetchPokemons(completion: @escaping ([Pokemon]) -> Void)
}

final class PokemonAPIService: PokemonService {
    func fetchPokemons(completion: @escaping ([Pokemon]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var pokemons: [Pokemon] = []
        
        for id in 1...706 {
            dispatchGroup.enter()
            fetchPokemon(id: id) { pokemon in
                if let pokemon = pokemon {
                    pokemons.append(pokemon)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(pokemons.sorted { $0.name < $1.name })
        }
    }
    
    private func fetchPokemon(id: Int, completion: @escaping (Pokemon?) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(id)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                completion(pokemon)
            } catch {
                print("Erro ao decodificar: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    func fetchPokemonEvolutions(for pokemonID: Int, completion: @escaping ([String]) -> Void) {
        let speciesURL = "https://pokeapi.co/api/v2/pokemon-species/\(pokemonID)/"
        
        guard let url = URL(string: speciesURL) else {
            print("❌ URL inválida")
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("❌ Erro ao buscar espécie:", error?.localizedDescription ?? "Desconhecido")
                completion([])
                return
            }

            do {
                let speciesData = try JSONDecoder().decode(PokemonSpecies.self, from: data)
                let evolutionChainURL = speciesData.evolutionChain.url
                self.fetchEvolutionChain(from: evolutionChainURL, completion: completion)
            } catch {
                print("❌ Erro ao decodificar JSON da espécie:", error.localizedDescription)
                completion([])
            }
        }.resume()
    }
    
    func fetchEvolutionChain(from url: String, completion: @escaping ([String]) -> Void) {
        guard let url = URL(string: url) else {
            print("❌ URL inválida")
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("❌ Erro ao buscar cadeia de evolução:", error?.localizedDescription ?? "Desconhecido")
                completion([])
                return
            }

            do {
                let evolutionData = try JSONDecoder().decode(EvolutionChain.self, from: data)
                let evolutions = self.extractEvolutions(from: evolutionData.chain)
                completion(evolutions)
            } catch {
                print("❌ Erro ao decodificar JSON da cadeia de evolução:", error.localizedDescription)
                completion([])
            }
        }.resume()
    }

    
    func extractEvolutions(from evolutionStep: EvolutionStep) -> [String] {
        var evolutions: [String] = [evolutionStep.species.name]

        for nextEvolution in evolutionStep.evolvesTo {
            evolutions.append(contentsOf: extractEvolutions(from: nextEvolution))
        }

        return evolutions
    }
    
    func fetchPokemonEvolutionsWithImages(for pokemonID: Int, completion: @escaping ([EvolutionData]) -> Void) {
        let speciesURL = "https://pokeapi.co/api/v2/pokemon-species/\(pokemonID)/"
        
        guard let url = URL(string: speciesURL) else {
            print("❌ URL inválida")
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("❌ Erro ao buscar espécie:", error?.localizedDescription ?? "Desconhecido")
                completion([])
                return
            }

            do {
                let speciesData = try JSONDecoder().decode(PokemonSpecies.self, from: data)
                let evolutionChainURL = speciesData.evolutionChain.url
                self.fetchEvolutionChainWithImages(from: evolutionChainURL, completion: completion)
            } catch {
                print("❌ Erro ao decodificar JSON da espécie:", error.localizedDescription)
                completion([])
            }
        }.resume()
    }

    
    func fetchEvolutionChainWithImages(from url: String, completion: @escaping ([EvolutionData]) -> Void) {
        guard let url = URL(string: url) else {
            print("❌ URL inválida")
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("❌ Erro ao buscar cadeia de evolução:", error?.localizedDescription ?? "Desconhecido")
                completion([])
                return
            }

            do {
                let evolutionData = try JSONDecoder().decode(EvolutionChain.self, from: data)
                let evolutionNames = self.extractEvolutions(from: evolutionData.chain)
                
                self.fetchPokemonImages(for: evolutionNames, completion: completion)
            } catch {
                print("❌ Erro ao decodificar JSON da cadeia de evolução:", error.localizedDescription)
                completion([])
            }
        }.resume()
    }

    func fetchPokemonImages(for pokemonNames: [String], completion: @escaping ([EvolutionData]) -> Void) {
        var evolutionsWithImages: [EvolutionData] = []
        let dispatchGroup = DispatchGroup()

        for name in pokemonNames {
            dispatchGroup.enter()
            
            let pokemonURL = "https://pokeapi.co/api/v2/pokemon/\(name)/"
            guard let url = URL(string: pokemonURL) else {
                dispatchGroup.leave()
                continue
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                defer { dispatchGroup.leave() }
                
                guard let data = data, error == nil else {
                    print("❌ Erro ao buscar Pokémon \(name):", error?.localizedDescription ?? "Desconhecido")
                    return
                }

                do {
                    let pokemonData = try JSONDecoder().decode(Pokemon.self, from: data)
                    let spriteURL = pokemonData.sprites.other?.officeArtwork?.frontDefault ?? pokemonData.sprites.frontDefault
                    
                    let evolutionInfo = EvolutionData(name: name.capitalized, imageURL: spriteURL)
                    evolutionsWithImages.append(evolutionInfo)
                } catch {
                    print("❌ Erro ao decodificar JSON do Pokémon \(name):", error.localizedDescription)
                }
            }.resume()
        }

        dispatchGroup.notify(queue: .main) {
            completion(evolutionsWithImages)
        }
    }


    
}
