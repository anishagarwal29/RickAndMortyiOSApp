//
//  CharacterDetailViewVM.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 4/11/24.
//

import Foundation

final class CharacterDetailViewVM {
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
}
