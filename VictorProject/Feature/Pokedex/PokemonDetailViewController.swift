//
//  PokemonDetailViewController.swift
//  VictorProject
//
//  Created by Joao Pacheco on 24/01/25.
//

import UIKit
import SnapKit
import Kingfisher
import SDWebImage
import AVFoundation

final class PokemonDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: PokemonDetailViewModel
    var audioPlayer: AVPlayer?
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private let pokemonImageView: SDAnimatedImageView = {
        let imageView = SDAnimatedImageView()
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
    
    private lazy var attackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var pokeImageView: UIImageView = {
        let pokeImageView = UIImageView()
        pokeImageView.image = UIImage(named: "pokeball")
        pokeImageView.contentMode = .scaleAspectFit
        return pokeImageView
    }()
    
    
    private lazy var attackLabel: UILabel = {
        let label = UILabel()
        label.text = "ATQ"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private lazy var attackValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private lazy var defenseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var defenseLabel: UILabel = {
        let label = UILabel()
        label.text = "DEF"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private lazy var defenseValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
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
    
    fileprivate func setFlipping() {
        // Inicia o containerView "de costas" (180° no eixo Y)
        //               containerView.layer.transform = CATransform3DMakeRotation(.pi, 0, 1, 0)
        //                containerView.alpha = 0.0
        
        // Aplica a animação de flip para aparecer
        UIView.animate(withDuration: 0.6, animations: {
            self.containerView.layer.transform = CATransform3DIdentity // Volta ao estado normal
            self.containerView.alpha = 1.0
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setFlipping()
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
        containerView.addSubview(attackView)
        attackView.addSubview(attackLabel)
        attackView.addSubview(attackValueLabel)
        containerView.addSubview(defenseView)
        defenseView.addSubview(defenseLabel)
        defenseView.addSubview(defenseValueLabel)
        containerView.addSubview(pokeImageView)
        
        setupConstraints()
        setupCloseButton()
        
        // Adicionar gesto de toque para tocar o áudio ao clicar na imagem
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pokemonImageTapped))
        pokemonImageView.isUserInteractionEnabled = true // Habilitar interação
        pokemonImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func pokemonImageTapped() {
        // Feedback tátil
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        
        UIView.animate(withDuration: 0.15, animations: {
                // Primeiro diminui
                self.pokemonImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.pokemonImageView.alpha = 0.7
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                // Depois volta com um leve giro
                self.pokemonImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).rotated(by: .pi * 0.03)
                self.pokemonImageView.alpha = 1.0
            } completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    // Volta à posição normal
                    self.pokemonImageView.transform = .identity
                }
            }
        }
        if let pokemonId = viewModel.pokemonId {
            playLocalAudio(pokemonId: pokemonId)
            viewModel.getEvolutions(for: pokemonId)
        }
        
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
        
        attackView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.width.equalTo(72)
            make.top.equalTo(detailsLabel.snp.bottom).offset(20)
            make.right.equalToSuperview().inset(32)
        }
        
        attackLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.bottom.equalToSuperview().inset(4)
            make.centerX.equalTo(attackView)
        }
        
        attackValueLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
        }
        
        pokeImageView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.width.equalTo(72)
            make.top.equalTo(detailsLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        defenseView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.width.equalTo(72)
            make.top.equalTo(detailsLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(32)
        }
        
        defenseLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.bottom.equalToSuperview().inset(4)
            make.centerX.equalTo(defenseView)
        }
        
        defenseValueLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
        }
        
        
    }
    
    private func setupCloseButton() {
        closeButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        nameLabel.text = viewModel.pokemonName
        detailsLabel.text = viewModel.pokemonDetails
        attackValueLabel.text = String(viewModel.pokemonAtack)
        attackLabel.text = "ATQ"
        defenseValueLabel.text = String(viewModel.pokemonDefense)
        defenseLabel.text = "DEF"
        
        if let pokemonID = viewModel.pokemonId { // Certifique-se de que tem um ID válido
            loadPokemonGif(id: pokemonID)
        } else {
            if let url = URL(string: viewModel.pokemonImage) {
                pokemonImageView.kf.setImage(with: url)
            }
            print("⚠️ ID do Pokémon não encontrado")
        }
    }
    
    @objc private func dismissModal() {
        UIView.animate(withDuration: 0.6, animations: {
            self.containerView.layer.transform = CATransform3DMakeRotation(.pi, 0, 1, 0) // Gira para sair
            self.containerView.alpha = 0.0
        }) { _ in
            self.dismiss(animated: false, completion: nil) // Fecha sem animação padrão
        }
    }
    
    
    private func loadPokemonGif(id: Int) {
        let gifName = "poke_\(id)" // Exemplo: "poke_1"
        
        // Verifica se o caminho do arquivo existe dentro do bundle
        if let gifPath = Bundle.main.path(forResource: gifName, ofType: "gif") {
            let gifURL = URL(fileURLWithPath: gifPath)
            let gifImage = SDAnimatedImage(contentsOfFile: gifURL.path)
            pokemonImageView.image = gifImage
            print("✅ GIF \(gifName) carregado com sucesso!")
        } else {
            print("❌ Erro: GIF \(gifName) não encontrado no Bundle!")
        }
    }
    
    private func playAudio(from url: URL) {
        if let player = audioPlayer {
            player.pause() // Pausa qualquer áudio que esteja tocando
        }
        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
        audioPlayer?.play()
        
        print("🎵 Tocando áudio: \(url.lastPathComponent)")
    }
    
    func playLocalAudio(pokemonId: Int) {
        let formattedId = String(format: "%03d", pokemonId)
        
        // Procura por arquivos que começam com o ID formatado
        if let audioPath = Bundle.main.paths(forResourcesOfType: "wav", inDirectory: nil)
            .first(where: { $0.contains("/\(formattedId) -") }) {
            
            let url = URL(fileURLWithPath: audioPath)
            playAudio(from: url)
            print("🎵 Tocando áudio: \(url.lastPathComponent)")
        } else {
            print("❌ Arquivo de áudio não encontrado para o Pokémon ID: \(pokemonId)")
        }

    }
}



