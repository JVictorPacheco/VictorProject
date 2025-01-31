import UIKit
import SnapKit

final class PokedexViewController: UIViewController{
    // MARK: - Properties
    private let viewModel: PokemonListViewModel
    var username: String = ""
    
    // MARK: - UI Components
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white.withAlphaComponent(0.9)
        return label
    }()
    
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Pokemon"
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.textColor = .black
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    // MARK: - Initialization
    init(viewModel: PokemonListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.loadPokemons()
        setupBindings()
        
        
    }
    
    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .blue
        
        setupWelcomeLabel()
        setupSearchBar()
        setupTableView()
        setupConstraints()
        
    }
    
    func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.delegate = self
    }
    
    private func setupWelcomeLabel() {
        view.addSubview(welcomeLabel)
        welcomeLabel.text = "Olá \(username), bem-vindo ao app!"
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupBindings() {
        viewModel.onPokemonsUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    
    
    private func setupConstraints() {
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel         .snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableView DataSource & Delegate

extension PokedexViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterPokemons(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


extension PokedexViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPokemons()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let pokemon = viewModel.pokemon(at: indexPath.row)
//        let detailVC = PokemonDetailViewController(pokemon: pokemon)
//        present(detailVC, animated: true)
        
        var content = cell.defaultContentConfiguration()
        content.text = pokemon.name.capitalized
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = viewModel.pokemon(at: indexPath.row)
        let detailVC = PokemonDetailViewController(pokemon: pokemon)
        detailVC.modalPresentationStyle = .overCurrentContext
        detailVC.modalTransitionStyle = .crossDissolve
        present(detailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.numberOfPokemons() == 0 {
            viewModel.loadPokemons()
        }
    }
}
