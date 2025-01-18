//
//  InfosApp.swift
//  VictorProject
//
//  Created by Joao Pacheco on 13/01/25.
//

import UIKit
import SnapKit

struct Pokemon: Codable {
    let name: String
    let sprites: Sprites
}

struct Sprites: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}



class InfosApp: UIViewController {
    
    // MARK: PROPRIEDADES
    //private let userName: String
    private var pokemons: [Pokemon] = []
    
//    init(userName: String) {
//        //self.userName = userName
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    var textoRecebido: String = ""

    var mensagem: String {
        return "Olá \(textoRecebido), bem-vindo ao app!"
    }
    
    
    // MARK: PROPRIEDADES COMPUTADAS
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
   
    
    private let mensagemLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white.withAlphaComponent(0.9)
        return label
        
    }()
    
    
    // MARK: METODOS DE CICLO DE VIDA DA TELA
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        viewSetup()
        setupConstraints()
        fetchPokemons()
    }
    
    
    func viewSetup() {
        view.addSubview(mensagemLabel)
        mensagemLabel.text = mensagem
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    // MARK: METODOS DE CICLO DE VIDA DA TELA
    
    private func fetchPokemons() {
        // Vamos buscar os primeiros 20 pokemons
        for id in 1...20 {
            let urlString = "https://pokeapi.co/api/v2/pokemon/\(id)"
            guard let url = URL(string: urlString) else { continue }
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                
                do {
                    let pokemon = try JSONDecoder().decode(Pokemon.self, from: data!)
                    DispatchQueue.main.async {
                        self.pokemons.append(pokemon)
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Erro ao decodificar: \(error)")
                }
            }.resume()
        }
    }
    
    
    
    private func setupConstraints() {
        mensagemLabel.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: mensagemLabel.bottomAnchor, constant: 20),
                    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ])
        
    }
}


extension InfosApp: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let pokemon = pokemons[indexPath.row]
        
        
        var content = cell.defaultContentConfiguration()
        content.text = pokemon.name.capitalized
        cell.contentConfiguration = content
        
        return cell
        
    }
    
}
