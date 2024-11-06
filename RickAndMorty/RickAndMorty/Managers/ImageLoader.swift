//
//  ImageLoader.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 4/11/24.
//

import Foundation

final class ImageLoader {
    static let shared = ImageLoader()
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    private init() {}
    
    /// Get image content with URL
    /// - Parameters:
    ///   - url: Source url
    ///   - completion: callback
    public func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey:key) {
            completion(.success(data as Data)) // NSData == Data | NSString == String
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
        
    }
}

