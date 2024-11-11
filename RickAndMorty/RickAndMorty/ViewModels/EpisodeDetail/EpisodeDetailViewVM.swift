//
//  EpisodeDetailViewVM.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 7/11/24.
//

import UIKit

protocol EpisodeDetailViewVMDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class EpisodeDetailViewVM {
    // MARK: - Properties
    private let endpointUrl: URL?
    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    enum SectionType {
        case information(viewModel: [EpisodeInfoCollectionViewCellVM])
        case characters(viewModel: [CharacterCollectionViewCellVM])
    }
    
    public weak var delegate: EpisodeDetailViewVMDelegate?
    
   public private(set) var cellViewModels: [SectionType] = []
    
    // MARK: - Init
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    public func character(at index: Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else {
            return nil
        }
        return dataTuple.characters[index]
    }
    
    
    // MARK: - Private
    
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else {
            return
        }
        
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        
        var createdString = episode.created
        if let date = CharacterInfoCollectionViewCellVM.dateFormatter.date(from: episode.created) {
            createdString = CharacterInfoCollectionViewCellVM.shortDateFormatter.string(from: date)
        }
        
        cellViewModels = [
            .information(viewModel: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString),
            ]),
            .characters(viewModel: characters.compactMap({ character in
                return CharacterCollectionViewCellVM(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image))
            }))
        ]
    }
    
    /// Fetch backing episode model
    public func fetchEpisodeData() {
        guard let url = endpointUrl, let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                print(String(describing: model))
                self?.fetchRelatedCharacter(episode: model)
            case .failure:
                break
            }
        }
    }
    
    private func fetchRelatedCharacter(episode: RMEpisode) {
        let requests: [RMRequest] = episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return RMRequest(url: $0)
        })
        
        // 10 of parallel request
        // Notified once all are done
        
        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        for request in requests {
            group.enter()
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }
        
        group.notify(queue: .main) {
            self.dataTuple = (episode: episode, characters: characters)
        }
    }
    
}
