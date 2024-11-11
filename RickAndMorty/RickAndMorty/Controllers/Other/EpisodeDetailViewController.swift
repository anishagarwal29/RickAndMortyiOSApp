//
//  EpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 6/11/24.
//

import UIKit

/// VC to show details about single episode
final class EpisodeDetailViewController: UIViewController, EpisodeDetailViewVMDelegate, EpisodeDetailViewDelegate {
    private let viewModel: EpisodeDetailViewVM
    
    private let detailView = EpisodeDetailView()
    
    // MARK: - Init
    
    init(url: URL?) {
        self.viewModel = EpisodeDetailViewVM(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(detailView)
        addConstraints()
        detailView.delegate = self
        title = "Episode"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        
        viewModel.delegate = self
        viewModel.fetchEpisodeData()

    }
    
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        ])
    }
    
    @objc
    private func didTapShare() {
        
    }
    
    // MARK: - View Dleegate
    
    func rmEpisodeDetailView(_ detailView: EpisodeDetailView, didSelectCharacter character: RMCharacter) {
        let vc = CharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - ViewModel Delegate
    
    func didFetchEpisodeDetails() {
        detailView.configure(with: viewModel)
    }

}
