import Foundation

protocol PokemonService {
    func fetchPokemons(completion: @escaping ([Pokemon]) -> Void)
}

final class PokemonAPIService: PokemonService {
    func fetchPokemons(completion: @escaping ([Pokemon]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var pokemons: [Pokemon] = []
        
        for id in 1...999 {
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
}
