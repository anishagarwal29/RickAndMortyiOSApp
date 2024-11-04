//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 4/11/24.
//

import UIKit

/// Controller to show info about single character
final class CharacterDetailViewController: UIViewController {
    private let viewModel: CharacterDetailViewVM

    init(viewModel: CharacterDetailViewVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Usupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
    }


}
