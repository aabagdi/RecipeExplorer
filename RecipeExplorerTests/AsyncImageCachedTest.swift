//
//  AsyncImageCachedTest.swift
//  RecipeExplorerTests
//
//  Created by Aadit Bagdi on 1/4/25.
//

import XCTest
import SwiftUI
@testable import RecipeExplorer

final class AsyncImageCachedTest: XCTestCase {
    var sut: AsyncImageCached<Image>!
    var testURL: URL!
    
    override func setUp() {
        super.setUp()
        testURL = URL(string: "https://example.com/test.jpg")!
        sut = AsyncImageCached(url: testURL) { phase in
            switch phase {
            case .empty:
                return Image(systemName: "photo")
            case .success(let image):
                return image
            case .failure:
                return Image(systemName: "exclamationmark.triangle")
            @unknown default:
                return Image(systemName: "questionmark")
            }
        }
    }
    
    override func tearDown() {
        sut = nil
        testURL = nil
        ImageCache.clearCache()
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.url, testURL)
    }
    
    func testCaching() {
        let testImage = Image(systemName: "star")
        ImageCache[testURL] = testImage
        XCTAssertNotNil(ImageCache[testURL])
    }
    
    func testMiss() {
        let errorURL = URL(string: "https://example.com/nonexistent.jpg")!
        XCTAssertNil(ImageCache[errorURL])
    }
    
    func testOverwrite() {
        let initialImage = Image(systemName: "star")
        let updatedImage = Image(systemName: "circle")
        ImageCache[testURL] = initialImage
        ImageCache[testURL] = updatedImage
        let cachedImage = ImageCache[testURL]
        XCTAssertNotNil(cachedImage)
    }
}
