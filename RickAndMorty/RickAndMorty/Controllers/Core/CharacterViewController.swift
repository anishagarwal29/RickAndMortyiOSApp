//
//  CharacterViewController.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 2/11/24.
//

import UIKit

/// Controller to show and search for characters
final class CharacterViewController: UIViewController, CharacterListViewDelegate {
    

    private let characterListView = CharacterListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Characters"
        setUpView()
    }
    
    private func setUpView() {
        characterListView.delegate = self
        view.addSubview(characterListView)
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - CharacterListViewDelegate
    
    func rmCharacterListView(_ rmCharacterListView: CharacterListView, didSelectCharacter character: RMCharacter) {
        // Open detail controller for specific character
        let viewModel = CharacterDetailViewVM(character: character)
        let detailVC = CharacterDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC , animated: true)
    }
    
}
