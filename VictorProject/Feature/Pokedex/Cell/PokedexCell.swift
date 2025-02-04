//
//  PokedexCell.swift
//  VictorProject
//
//  Created by André Pacheco on 03/02/25.
//

import Foundation
import UIKit

class PokedexCell: UITableViewCell {
    private let stripeLayer = CAShapeLayer()
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12 // Cantos mais arredondados são mais amigáveis
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
        view.layer.borderWidth = 1
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.1
        
        return view
    }()
    
    private let regionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        // Cores do gradiente similar ao da imagem
        gradient.colors = [
            UIColor.black.withAlphaComponent(0.1).cgColor,  // Cinza escuro suave
                       UIColor.darkGray.withAlphaComponent(0.2).cgColor // Quase preto
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        return gradient
    }()
    
    private let diagonalView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 173/255, green: 216/255, blue: 247/255, alpha: 0.7)
        return view
    }()
    
    private let bubblePatternView: UIView = {
        let view = UIView()
        
        // Adiciona pequenos círculos decorativos
        for _ in 0...10 {
            let bubble = UIView()
            bubble.backgroundColor = UIColor.white.withAlphaComponent(0.15)
            bubble.layer.cornerRadius = CGFloat.random(in: 4...8)
            bubble.frame = CGRect(
                x: CGFloat.random(in: 0...200),
                y: CGFloat.random(in: 0...80),
                width: CGFloat.random(in: 8...16),
                height: CGFloat.random(in: 8...16)
            )
            view.addSubview(bubble)
        }
        
        return view
    }()
    
    private let statsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    private let attackLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white.withAlphaComponent(0.8)
        return label
    }()
    
    private let defenseLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white.withAlphaComponent(0.8)
        return label
    }()
    
    private let lifeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white.withAlphaComponent(0.8)
        return label
    }()
    
    private let speedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white.withAlphaComponent(0.8)
        return label
    }()
    
    private let typesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white.withAlphaComponent(0.8)
        return label
    }()
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let diagonalBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
        return view
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupShadow()

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Atualiza o frame do gradiente
        gradientLayer.frame = contentView.bounds
        stripeLayer.frame = contentView.bounds
        
        // Posiciona a view diagonal
        
        let diagonalWidth = containerView.bounds.width * 0.7 // Ajuste esse valor para controlar o tamanho
        let diagonalHeight = containerView.bounds.height * 2
        diagonalView.frame = CGRect(x: contentView.bounds.width - diagonalWidth,
                                    y: -diagonalHeight/2,
                                    width: diagonalWidth,
                                    height: diagonalHeight)
        
        // Rotação para apontar para direita
        diagonalView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
    }
    
    private func setupShadow() {
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 2, height: 4)
        contentView.layer.shadowRadius = 6
    }
        
    
    
    // MARK: - Setup
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(diagonalBackgroundView)
        containerView.addSubview(bubblePatternView)
        containerView.addSubview(regionNameLabel)
        containerView.addSubview(statsStackView)
        containerView.addSubview(pokemonImageView)
        containerView.addSubview(lifeLabel)
        containerView.addSubview(typesLabel)
       // containerView.addSubview(diagonalView)  // Certifique-se que está sendo adicionado
        
        statsStackView.addArrangedSubview(attackLabel)
        statsStackView.addArrangedSubview(defenseLabel)
        statsStackView.addArrangedSubview(speedLabel)
        
        containerView.bringSubviewToFront(pokemonImageView)
       // containerView.sendSubviewToBack(diagonalView)
                
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        // Configurar constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        diagonalBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        regionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        diagonalView.translatesAutoresizingMaskIntoConstraints = false
        
        lifeLabel.translatesAutoresizingMaskIntoConstraints = false
        speedLabel.translatesAutoresizingMaskIntoConstraints = false
        typesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.heightAnchor.constraint(equalToConstant: 120),
            
            regionNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            regionNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            typesLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            typesLabel.leadingAnchor.constraint(equalTo: regionNameLabel.trailingAnchor, constant: 16),
            
            statsStackView.topAnchor.constraint(equalTo: regionNameLabel.bottomAnchor, constant: 8),
            statsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            pokemonImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pokemonImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            pokemonImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.4),
            pokemonImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.8)
        ])

        // Configurações da célula
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        

    }
    
    // MARK: - Configuration
    func configure(with pokemon: Pokemon) {
        
        regionNameLabel.text = pokemon.name.capitalized
        attackLabel.text = "Atq: \(pokemon.attack)"
        defenseLabel.text = "Def: \(pokemon.defense)"
        speedLabel.text = "Vel: \(pokemon.speed)"
        typesLabel.text = pokemon.typeEmojis
        
        
//        let imagemURLString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemon.id).png"
        if let url = URL(string: pokemon.sprites.other?.officeArtwork?.frontDefault ?? pokemon.sprites.frontDefault ) {
            pokemonImageView.kf.setImage(with: url)
        }
        
    }


}
