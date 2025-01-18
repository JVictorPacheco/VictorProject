
//
//  ViewController.swift
//  PersonalProject
//
//  Created by Joao Pacheco on 05/01/25.
//
import UIKit

import SnapKit


class ViewController: UIViewController {
    
    // MARK: PROPRIEDADES
    
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
        textField.placeholder = "Enter your name"
        textField.textColor = .white.withAlphaComponent(0.9)
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        textField.textAlignment = .center
        
        
        let placeholderText = "Enter your name"
        let placeholderColor = UIColor.white.withAlphaComponent(0.7) // Ajuste a opacidade se desejar
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        
        return textField
    }()
    
    private var button: UIButton = {
        let button = UIButton()
        button.setTitle("Advance", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(buttonNavigation), for: .touchUpInside)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    // MARK: METODOS
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewSetup()
        setupConstraints()
    }
    
    func viewSetup() {
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
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    @objc func buttonNavigation() {
        if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || textField.text == nil {
            let alert = UIAlertController(title: "Error", message: "Please enter your name", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            alert.view.alpha = 0.9
            alert.view.backgroundColor = .black
            alert.view.tintColor = .blue
            
        } else {
            if let textInputModel = textField.text {
                let textInputModel = textInputModel
                let secondScreen = InfosApp()
                secondScreen.textoRecebido = textField.text ?? ""
                navigationController?.pushViewController(secondScreen, animated: true)
            }
        }
        
    }
    
    
    private func setupConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.snp.makeConstraints{ make in
            make.centerX.equalToSuperview() // Centraliza horizontal e verticalmente
            make.centerY.equalToSuperview().offset(100)
            make.width.equalTo(250)
            make.height.equalTo(50)
            
        }
        
        textField.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.equalTo(250)
            make.height.equalTo(40)
        }
        
        logoImageView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(textField.snp.top).offset(-70)
            make.leading.equalTo(textField.snp.leading).offset(-50)
            make.width.equalTo(270)
            make.height.equalTo(150)
            
        }
        
    }
    
    
}
