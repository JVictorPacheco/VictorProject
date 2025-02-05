import UIKit
import SnapKit

final class WellcomeLoginViewController: UIViewController {
    // MARK: - UI Components
//    private let gradientLayer: CAGradientLayer = {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [UIColor.white.cgColor, UIColor.blue.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.2, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
//        return gradientLayer
//    }()
    
    private var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pokemon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Coloque o seu nome aqui..."
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        textField.textAlignment = .center
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "Coloque o seu nome aqui...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        
        return textField
    }()
    
    private var button: UIButton = {
        let button = UIButton()
        button.setTitle("Avance", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(buttonNavigation), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewSetup()
        setupConstraints()
    }
    
    
    // MARK: - Setup
    private func viewSetup() {
        //let gradientView = UIView()
        //view.addSubview(gradientView)
        
//        gradientView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        
//        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(button)
        view.addSubview(textField)
        view.addSubview(logoImageView)
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
    
    
    private func setupConstraints() {
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(100)
            make.width.equalTo(250)
            make.height.equalTo(50)
        }
        
        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.equalTo(250)
            make.height.equalTo(40)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(textField.snp.top).offset(-70)
            make.leading.equalTo(textField.snp.leading).offset(-50)
            make.width.equalTo(270)
            make.height.equalTo(150)
        }
    }
    
    // MARK: - Actions
    @objc private func buttonNavigation() {
        if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || textField.text == nil {
            showAlert()
        } else {
            navigateToPokedex()
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Erro",
                                    message: "Por favor insira um nome para o seu pokémon!",
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        
        alert.view.alpha = 0.9
        alert.view.backgroundColor = .black
        alert.view.tintColor = .blue
    }
    
    private func navigateToPokedex() {
        let viewModel = PokemonListViewModel()
        let pokedexVC = PokedexViewController(viewModel: viewModel)
        pokedexVC.username = textField.text ?? ""
        navigationController?.pushViewController(pokedexVC, animated: true)
    }
}

extension WellcomeLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Fecha o teclado
        return true
    }
}
