//
//  RecipeLoader.swift
//  RecipeExplorer
//
//  Created by Aadit Bagdi on 1/3/25.
//

import Foundation


extension MainView {
@Observable
    class MainViewModel {
        var recipeList = [Recipe]()
        private let urlSession: URLSession
        
        init(urlSession: URLSession = .shared) {
            self.urlSession = urlSession
        }
        
        @MainActor
        func fetchRecipes() async throws {
            let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
            guard let url else {
                throw URLError(.badURL)
            }
            let (data, _) = try await urlSession.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(RecipeResponse.self, from: data)
            self.recipeList = response.recipes.sorted { $0.name < $1.name }
        }
    }
}
