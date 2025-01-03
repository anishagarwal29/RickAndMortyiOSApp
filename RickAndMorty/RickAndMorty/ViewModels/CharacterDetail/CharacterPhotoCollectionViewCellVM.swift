//
//  CharacterPhotoCollectionViewCellVM.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 5/11/24.
//

import Foundation

final class CharacterPhotoCollectionViewCellVM {
    private let imageUrl: URL?
    
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageUrl = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        ImageLoader.shared.downloadImage(imageUrl, completion: completion)
    }
    
}
