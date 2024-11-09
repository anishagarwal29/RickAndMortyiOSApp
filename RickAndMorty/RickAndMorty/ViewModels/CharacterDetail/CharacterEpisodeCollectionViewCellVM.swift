//
//  CharacterEpisodeCollectionViewCellVM.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 5/11/24.
//

import UIKit

protocol EpisodeDataRender {
    var name: String { get }
    var air_date: String { get }
    var episode: String { get }
}

final class CharacterEpisodeCollectionViewCellVM: Hashable, Equatable {
    
    private let episodeDataUrl: URL?
    private var isFetching = false
    private var dataBlock: ((EpisodeDataRender) -> Void)?
    public var borderColor: UIColor
    
    private var episode: RMEpisode? {
        didSet {
            guard let model = episode else {
                return
            }
            dataBlock?(model)
        }
    }
    
    // MARK: - Init
    
    init (episodeDataUrl: URL?, borderColor: UIColor = .systemMint) {
        self.episodeDataUrl = episodeDataUrl
        self.borderColor = borderColor
    }
    // MARK: - Public
    
    public func registerForData(_ block: @escaping(EpisodeDataRender) -> Void) {
        self.dataBlock = block
    }
    
    public func fetchEpisode() {
        guard !isFetching else {
            if let model = episode {
                dataBlock?(model)
            }
            return
        }
        
        guard let url = episodeDataUrl, let request = RMRequest(url: url) else {
            return
        }
        
        isFetching = true
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.episode = model
                }
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
    }
    
    static func == (lhs: CharacterEpisodeCollectionViewCellVM, rhs: CharacterEpisodeCollectionViewCellVM) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
