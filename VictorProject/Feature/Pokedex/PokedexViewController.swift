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
        searchBar.placeholder = "Procure o seu pokemon favorito!"
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
        buttonBackColor()
    
        
    }
    
    func buttonBackColor() {
        navigationController?.navigationBar.tintColor = .white
    }
    
    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .blue
        
        setupWelcomeLabel()
        setupSearchBar()
        setupTableView()
        setupConstraints()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Garantir que o fundo seja recriado sempre que o layout for atualizado
        setupGradient()
        setupHoneycombPattern()
    }
    
    // MARK: - Setup Gradient
    private func setupGradient() {
        view.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemBlue.cgColor,
            UIColor.systemPurple.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Setup Honeycomb (Padrão de Colmeia)
    private func setupHoneycombPattern() {
        view.layer.sublayers?.removeAll { $0 is CAShapeLayer }
        
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        let hexSize: CGFloat = 20 // Tamanho dos hexágonos
        let hexWidth = hexSize * 2
        let hexHeight = sqrt(3) * hexSize
        let spacing = hexSize * 0.2 // Pequeno espaço entre os hexágonos
        
        let width = view.bounds.width
        let height = view.bounds.height
        
        for x in stride(from: 0, to: width, by: hexWidth + spacing) {
            for y in stride(from: 0, to: height, by: hexHeight + spacing) {
                
                let offsetX = (Int(y / hexHeight) % 2 == 0) ? 0 : hexWidth / 2
                
                let centerX = x + offsetX
                let centerY = y
                
                let hexagonPath = createHexagonPath(center: CGPoint(x: centerX, y: centerY), size: hexSize)
                path.append(hexagonPath)
            }
        }
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.withAlphaComponent(0.15).cgColor // Apenas as linhas
        shapeLayer.lineWidth = 1
        shapeLayer.fillColor = UIColor.clear.cgColor // Remove qualquer preenchimento
        
        view.layer.insertSublayer(shapeLayer, above: view.layer.sublayers?.first)
    }
    
    // Função auxiliar para desenhar um hexágono sem preenchimento
    private func createHexagonPath(center: CGPoint, size: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        for i in 0..<6 {
            let angle = CGFloat(i) * (CGFloat.pi / 3) // 60 graus por lado
            let x = center.x + size * cos(angle)
            let y = center.y + size * sin(angle)
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.close()
        return path
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
