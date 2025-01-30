//
//  PokemonDetailViewController.swift
//  VictorProject
//
//  Created by Joao Pacheco on 24/01/25.
//

import UIKit
import SnapKit
import Kingfisher

final class PokemonDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: PokemonDetailViewModel
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(white: 0.9, alpha: 1.0)
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Fechar", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    // MARK: - Initialization
    init(pokemon: Pokemon) {
        self.viewModel = PokemonDetailViewModel(pokemon: pokemon)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init (coder:) has not been implemented")
    }
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupView()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Garantir que o fundo seja recriado sempre que o layout for atualizado
        setupGradient()
        setupHoneycombPattern()
    }
    
    // MARK: - Setup Gradient
    private func setupGradient() {
        containerView.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemBlue.cgColor,
            UIColor.systemPurple.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = containerView.bounds
        
        containerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Setup Honeycomb (Padrão de Colmeia)
    private func setupHoneycombPattern() {
        containerView.layer.sublayers?.removeAll { $0 is CAShapeLayer }
        
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        let hexSize: CGFloat = 20 // Tamanho dos hexágonos
        let hexWidth = hexSize * 2
        let hexHeight = sqrt(3) * hexSize
        let spacing = hexSize * 0.2 // Pequeno espaço entre os hexágonos
        
        let width = containerView.bounds.width
        let height = containerView.bounds.height
        
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
        
        containerView.layer.insertSublayer(shapeLayer, above: containerView.layer.sublayers?.first)
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
    
    // MARK: - Setup View
    private func setupView() {
        view.addSubview(containerView)
        containerView.addSubview(pokemonImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(detailsLabel)
        containerView.addSubview(closeButton)
        
        setupConstraints()
        setupCloseButton()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        pokemonImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(200)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(pokemonImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        detailsLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        closeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(45)
        }
    }
    
    private func setupCloseButton() {
        closeButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        nameLabel.text = viewModel.pokemonName
        detailsLabel.text = viewModel.pokemonDetails
        
        if let url = URL(string: viewModel.pokemonImage) {
            pokemonImageView.kf.setImage(with: url)
        }
    }
    
    @objc private func dismissModal() {
        dismiss(animated: true)
    }
}
