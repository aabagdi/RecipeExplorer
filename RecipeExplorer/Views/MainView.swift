//
//  ContentView.swift
//  RecipeExplorer
//
//  Created by Aadit Bagdi on 1/3/25.
//

import SwiftUI

struct MainView: View {
    @State var viewModel = MainViewModel()
    @State var recipeLoadFailure = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color(red: 255/255, green: 219/255, blue: 187/255), Color.orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                if !viewModel.recipeList.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(viewModel.recipeList) { recipe in
                                RecipeCardView(recipe: recipe)
                                    .containerRelativeFrame([.horizontal, .vertical])
                                    .scrollTransition(axis: .horizontal) { content, phase in
                                        content
                                            .rotation3DEffect(.degrees(phase.value * -30), axis: (x: 0, y: 1, z: 0))
                                            .scaleEffect(x: phase.isIdentity ? 1 : 0.8, y: phase.isIdentity ? 1 : 0.8)
                                    }
                            }
                        }
                    }
                    .padding()
                    .toolbar {
                        Button {
                            Task {
                                do {
                                    try await viewModel.fetchRecipes()
                                } catch {
                                    recipeLoadFailure = true
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.trianglehead.clockwise")
                        }
                    }
                } else {
                    Text("No recipes found, sorry!")
                }
            }
            .alert("Error loading recipes!",
                   isPresented: $recipeLoadFailure) {
                Button("OK") {
                    recipeLoadFailure = false
                }
            }
                .task {
                    do {
                        try await viewModel.fetchRecipes()
                    } catch {
                        recipeLoadFailure = true
                    }
                }
            }
        }
    }
    
    #Preview {
        MainView()
    }
