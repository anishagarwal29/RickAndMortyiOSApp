//
//  File.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 3/11/24.
//

import Foundation

final class CharacterCollectionViewCellVM: Hashable, Equatable {
    
    public let characterName: String
    private let characterStatus: CharacterStatus
    private let characterImageUrl: URL?
    
    static func == (lhs: CharacterCollectionViewCellVM, rhs: CharacterCollectionViewCellVM) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageUrl)
        
    }
    
    // MARK: - INIT
    
    init(characterName: String, characterStatus: CharacterStatus, characterImageUrl: URL?) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
    }
    
    public var characterStatusText: String {
        return "Status: \(characterStatus.text)"
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        // TODO: Abstract to Image Manager
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
    
}
