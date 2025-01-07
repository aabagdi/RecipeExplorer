//
//  VideoView.swift
//  RecipeExplorer
//
//  Created by Aadit Bagdi on 1/3/25.
//

import SwiftUI
import WebKit

struct VideoView: UIViewRepresentable {
    let videoURL: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: videoURL) else {
            return
        }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: url))
    }
}
