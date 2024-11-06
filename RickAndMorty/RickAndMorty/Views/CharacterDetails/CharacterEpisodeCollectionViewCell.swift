//
//  CharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 5/11/24.
//

import UIKit

final class CharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "CharacterEpisodeCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpConstraints() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with viewModel: CharacterEpisodeCollectionViewCellVM) {
        
    }
}
