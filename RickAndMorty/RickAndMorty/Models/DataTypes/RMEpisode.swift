//
//  Episode.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 2/11/24.
//

import Foundation

struct RMEpisode: Codable, EpisodeDataRender {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
