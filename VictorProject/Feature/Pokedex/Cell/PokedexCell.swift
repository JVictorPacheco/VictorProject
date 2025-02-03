//
//  PokedexCell.swift
//  VictorProject
//
//  Created by André Pacheco on 03/02/25.
//

import Foundation
import UIKit

class PokedexCell: UITableViewCell {
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12 // Cantos mais arredondados são mais amigáveis
        view.clipsToBounds = true
        
        // Gradiente suave com cores mais vibrantes mas não agressivas
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 116/255, green: 185/255, blue: 255/255, alpha: 1).cgColor,  // Azul claro
            UIColor(red: 168/255, green: 216/255, blue: 255/255, alpha: 1).cgColor   // Azul mais claro
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Adiciona sombra suave para dar profundidade
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.borderColor = UIColor.white.cgColor
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
            UIColor(red: 235/255, green: 245/255, blue: 251/255, alpha: 1).cgColor,
            UIColor(red: 220/255, green: 237/255, blue: 249/255, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
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
        for _ in 0...5 {
            let bubble = UIView()
            bubble.backgroundColor = UIColor.white.withAlphaComponent(0.15)
            bubble.layer.cornerRadius = CGFloat.random(in: 4...8)
            bubble.frame = CGRect(
                x: CGFloat.random(in: 0...200),
                y: CGFloat.random(in: 0...80),
                width: CGFloat.random(in: 8...32),
                height: CGFloat.random(in: 8...32)
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
        label.textColor = .darkGray
        return label
    }()
    
    private let defenseLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
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
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Atualiza o frame do gradiente
        gradientLayer.frame = contentView.bounds
        
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
       // containerView.addSubview(diagonalView)  // Certifique-se que está sendo adicionado
        
        statsStackView.addArrangedSubview(attackLabel)
        statsStackView.addArrangedSubview(defenseLabel)
        
        containerView.bringSubviewToFront(pokemonImageView)
       // containerView.sendSubviewToBack(diagonalView)
                
        // Configurar constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        diagonalBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        regionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        diagonalView.translatesAutoresizingMaskIntoConstraints = false  // Adicione esta linha
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.heightAnchor.constraint(equalToConstant: 100),
            
            regionNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            regionNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            statsStackView.topAnchor.constraint(equalTo: regionNameLabel.bottomAnchor, constant: 8),
            statsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            // Constraints para o diagonalView
//            diagonalView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//            diagonalView.topAnchor.constraint(equalTo: containerView.topAnchor),
//            diagonalView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7),
//            diagonalView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            
            pokemonImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pokemonImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            pokemonImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.4),
            pokemonImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.8)
        ])

        // Configurações da célula
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        
        let touchDown = UIViewPropertyAnimator(duration: 0.1, curve: .easeInOut) {
            self.containerView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }
            
        let touchUp = UIViewPropertyAnimator(duration: 0.1, curve: .easeInOut) {
            self.containerView.transform = .identity
        }
    }
    
    // MARK: - Configuration
    func configure(with pokemon: Pokemon) {
        
        regionNameLabel.text = pokemon.name
        attackLabel.text = "Atq: \(pokemon.attack)"
        defenseLabel.text = "Def: \(pokemon.defense)"
        
//        let imagemURLString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemon.id).png"
        if let url = URL(string: pokemon.sprites.other?.officeArtwork?.frontDefault ?? pokemon.sprites.frontDefault ) {
            pokemonImageView.kf.setImage(with: url)
        }
        
    }


}
