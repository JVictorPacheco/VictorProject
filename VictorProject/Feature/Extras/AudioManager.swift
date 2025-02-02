//
//  AudioManager.swift
//  VictorProject
//
//  Created by André Pacheco on 01/02/25.
//

import AVFoundation

class AudioManager {
    private var audioPlayer: AVPlayer?
    
    func playOGGAudio(from url: URL) {
        // Download do arquivo OGG
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else {
                print("❌ Erro no download: \(error?.localizedDescription ?? "Desconhecido")")
                return
            }
            
            do {
                // Criar um arquivo temporário para o áudio
                let tempURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent(UUID().uuidString)
                    .appendingPathExtension("mp3") // Vamos tentar como MP3 primeiro
                
                try data.write(to: tempURL)
                
                // Criar um AVAudioPlayer para leitura
                let asset = AVAsset(url: tempURL)
                let playerItem = AVPlayerItem(asset: asset)
                
                DispatchQueue.main.async {
                    self?.audioPlayer = AVPlayer(playerItem: playerItem)
                    self?.audioPlayer?.play()
                    print("🎵 Tentando tocar áudio...")
                }
                
                // Observar se houve erro na reprodução
                NotificationCenter.default.addObserver(forName: .AVPlayerItemFailedToPlayToEndTime, object: playerItem, queue: .main) { _ in
                    print("❌ Erro ao tocar o áudio")
                }
                
            } catch {
                print("❌ Erro no processamento: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func stop() {
        audioPlayer?.pause()
    }
    
    func cleanup() {
        // Limpar arquivos temporários
        let tempDirectory = FileManager.default.temporaryDirectory
        try? FileManager.default.contentsOfDirectory(at: tempDirectory, includingPropertiesForKeys: nil)
            .forEach { try FileManager.default.removeItem(at: $0) }
    }
}
