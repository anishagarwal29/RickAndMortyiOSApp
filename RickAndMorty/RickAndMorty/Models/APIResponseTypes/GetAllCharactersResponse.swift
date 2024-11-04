//
//  GetAllCharactersResponse.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 3/11/24.
//

import Foundation

struct GetAllCharactersResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMCharacter]
}
