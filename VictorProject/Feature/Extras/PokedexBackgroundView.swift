//
//  PokedexBackgroundView.swift
//  VictorProject
//
//  Created by André Pacheco on 04/02/25.
//

import Foundation

import UIKit

class PokedexBackgroundView: UIView {
    
    private let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHoneycombPattern()
        animateHoneycombFloat() // Ativar animação
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHoneycombPattern() {
        layer.sublayers?.removeAll { $0 is CAShapeLayer }
        
        let path = UIBezierPath()
        
        let hexSize: CGFloat = 22 // Tamanho dos hexágonos
        let hexWidth = hexSize * 2
        let hexHeight = sqrt(3) * hexSize
        let spacing = hexSize * 0.2 // Pequeno espaço entre os hexágonos
        
        let width = bounds.width
        let height = bounds.height
        
        for x in stride(from: 0, to: width + hexWidth, by: hexWidth + spacing) {
            for y in stride(from: 0, to: height + hexHeight, by: hexHeight + spacing) {
                
                let offsetX = (Int(y / hexHeight) % 2 == 0) ? 0 : hexWidth / 2
                
                let centerX = x + offsetX
                let centerY = y
                
                let hexagonPath = createHexagonPath(center: CGPoint(x: centerX, y: centerY), size: hexSize)
                path.append(hexagonPath)
            }
        }
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.withAlphaComponent(0.15).cgColor // Linhas suaves
        shapeLayer.lineWidth = 1
        shapeLayer.fillColor = UIColor.clear.cgColor // Sem preenchimento
        
        layer.insertSublayer(shapeLayer, at: 0)
    }
    
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
    
    // 🚀 **Animação de Flutuação**
    private func animateHoneycombFloat() {
        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        animation.fromValue = -25 // Move para cima
        animation.toValue = 25 // Move para baixo
        animation.duration = 6.0 // Velocidade da animação
        animation.autoreverses = true
        animation.repeatCount = .infinity
        
        shapeLayer.add(animation, forKey: "honeycombFloat")
    }
    
    private func animateHoneycombPulse() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0 // Tamanho normal
        animation.toValue = 1.1 // Leve expansão
        animation.duration = 2.0 // Tempo de expansão
        animation.autoreverses = true // Volta ao tamanho original
        animation.repeatCount = .infinity // Anima para sempre
        
        shapeLayer.add(animation, forKey: "honeycombPulse")
    }
}
