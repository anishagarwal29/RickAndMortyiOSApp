//
//  CharacterInfoCollectionViewCellVM.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 5/11/24.
//

import Foundation

final class CharacterInfoCollectionViewCellVM {
    public let value: String
    public let title: String
    
    init(value: String, title: String) {
        self.title = title
        self.value = value
    }
}
