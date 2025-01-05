//
//  RecipeCardView.swift
//  RecipeExplorer
//
//  Created by Aadit Bagdi on 1/3/25.
//

import SwiftUI

struct RecipeCardView: View {
    let recipe : Recipe
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
            VStack {
                if let urlString = recipe.photoUrlLarge,
                   let url = URL(string: urlString) {
                    AsyncImageCached(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        case .failure(let error):
                            Text(error.localizedDescription)
                        case .empty:
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        @unknown default:
                            Color.gray
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Text(recipe.name)
                    .font(.title)
                VideoView(videoURL: recipe.youtubeUrl ?? "")
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
                Text("Cuisine: \(recipe.cuisine)")
                Text("Source: \(recipe.sourceUrl ?? "Unknown source")")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
