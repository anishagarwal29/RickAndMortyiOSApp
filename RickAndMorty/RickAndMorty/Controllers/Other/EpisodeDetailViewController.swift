//
//  EpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 6/11/24.
//

import UIKit

/// VC to show details about single episode
final class EpisodeDetailViewController: UIViewController {
    private let url: URL?
    
    init(url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.backgroundColor = .systemGreen
    }

}
