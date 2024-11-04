//
//  Location.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 2/11/24.
//

import Foundation

struct RMLocation: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
                
}
