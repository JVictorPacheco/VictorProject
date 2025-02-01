import UIKit
import SnapKit

final class WelcomeViewController: UIViewController {
    // MARK: - UI Components
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.blue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.2, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        return gradientLayer
    }()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    // MARK: - Setup
    private func viewSetup() {
        let gradientView = UIView()
        view.addSubview(gradientView)
        
        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(button)
        view.addSubview(textField)
        view.addSubview(logoImageView)
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
