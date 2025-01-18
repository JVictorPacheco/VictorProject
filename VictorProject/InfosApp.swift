//
//  InfosApp.swift
//  VictorProject
//
//  Created by Joao Pacheco on 13/01/25.
//

import UIKit
import SnapKit

class InfosApp: UIViewController {
    
    // MARK: PROPRIEDADES
    var textoRecebido: String = ""
    
    var mensagem: String {
        return "Olá \(textoRecebido), bem-vindo ao app!"
    }
    
    private let mensagemLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white.withAlphaComponent(0.9)
        return label
        
    }()
    
    
    // MARK: METODOS
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        viewSetup()
        setupConstraints()
    }
    
    
    func viewSetup() {
        view.addSubview(mensagemLabel)
        mensagemLabel.text = mensagem
        
    }
    
    
    private func setupConstraints() {
        mensagemLabel.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
