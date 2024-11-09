//
//  GetAllEpisodesResponse.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 7/11/24.
//

import Foundation

struct GetAllEpisodesResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMEpisode]
}

