import Foundation

final class PokemonListViewModel {
    // MARK: - Properties
    private let service: PokemonService
    private var pokemons: [Pokemon] = []
    
    var onPokemonsUpdated: (() -> Void)?
    
    // MARK: - Initialization
    init(service: PokemonService = PokemonAPIService()) {
        self.service = service
    }
    
    // MARK: - Public Methods
    func loadPokemons() {
        service.fetchPokemons { [weak self] pokemons in
            self?.pokemons = pokemons
            self?.onPokemonsUpdated?()
        }
    }
    
    func numberOfPokemons() -> Int {
        return pokemons.count
    }
    
    func pokemon(at index: Int) -> Pokemon {
        return pokemons[index]
    }
}
