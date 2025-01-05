//
//  Recipe.swift
//  RecipeExplorer
//
//  Created by Aadit Bagdi on 1/3/25.
//

import Foundation

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable, Identifiable {
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let sourceUrl: String?
    let id: String
    let youtubeUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoUrlLarge
        case photoUrlSmall
        case sourceUrl
        case id = "uuid"
        case youtubeUrl
    }
}
