import Foundation

final class PokemonListViewModel {
    // MARK: - Properties
    private let service: PokemonService
    private var allPokemons: [Pokemon] = []
    private var filteredPokemons: [Pokemon] = []
    private var searchText: String = ""
    
    var onPokemonsUpdated: (() -> Void)?
    
    // MARK: - Initialization
    init(service: PokemonService = PokemonAPIService()) {
        self.service = service
    }
    
    // MARK: - Public Methods
    func loadPokemons() {
        service.fetchPokemons { [weak self] pokemons in
            self?.allPokemons = pokemons
            self?.filterPokemons()
        }
    }
    
    func numberOfPokemons() -> Int {
        return filteredPokemons.count
    }
    
    func pokemon(at index: Int) -> Pokemon {
        return filteredPokemons[index]
    }
    
    func filterPokemons(with searchText: String = "") {
        self.searchText = searchText.lowercased()
        
        if self.searchText.isEmpty {
            filteredPokemons = allPokemons
        } else {
            filteredPokemons = allPokemons.filter { pokemon in
                pokemon.name.lowercased().contains(self.searchText)
            }
        }
        
        onPokemonsUpdated?()
    }
}
