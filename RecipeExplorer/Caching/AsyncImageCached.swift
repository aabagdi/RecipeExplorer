//
//  AsyncImageCache.swift
//  RecipeExplorer
//
//  Created by Aadit Bagdi on 1/4/25.
//

import Foundation
import SwiftUI

struct AsyncImageCached<Content>: View where Content : View {
    internal let url: URL
    internal let scale: CGFloat
    internal let transaction: Transaction
    internal let content: (AsyncImagePhase) -> Content
    
    init(url: URL,
         scale: CGFloat = 1.0,
         transaction: Transaction = Transaction(),
         @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View {
        if let cached = ImageCache[url] {
            content(.success(cached))
        } else {
            AsyncImage(url: url, scale: scale, transaction: transaction) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }
    
    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            ImageCache[url] = image
        }
        return content(phase)
    }
}

internal class ImageCache {
    static private var cache = [URL : Image]()
    
    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
    
    static func clearCache() {
        cache.removeAll()
    }
}
