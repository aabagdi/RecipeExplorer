//
//  MainViewModelTest.swift
//  RecipeExplorerTests
//
//  Created by Aadit Bagdi on 1/4/25.
//

import XCTest
@testable import RecipeExplorer

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("No request handler provided.")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            XCTFail("Error handling the request: \(error)")
        }
    }
    
    override func stopLoading() {}
}

final class MainViewModelTest: XCTestCase {
    
    var sut : MainView.MainViewModel!
    var session : URLSession!
    
    override func setUp() {
        super.setUp()
        
        session = {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.protocolClasses = [MockURLProtocol.self]
            return URLSession(configuration: configuration)
        }()
        
        sut = MainView.MainViewModel(urlSession: session)
        
    }
    
    override func tearDown() {
        sut = nil
        session = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }
    
    func testFetchJSON() async throws {
        let data = """
         {
             "recipes": [
                 {
                     "cuisine": "Malaysian",
                     "name": "Apam Balik",
                     "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                     "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                     "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                     "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                     "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                 },
                 {
                     "cuisine": "British",
                     "name": "Apple & Blackberry Crumble",
                     "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                     "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                     "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                     "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                     "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
                 }
            ]
         }
         """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.absoluteString, "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
            
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            
            return (response, data)
        }
        
        // Add the actual test call and assertions here
        try await sut.fetchRecipes()
        
        // Add assertions to verify the fetched data
        XCTAssertFalse(sut.recipeList.isEmpty)
        XCTAssertEqual(sut.recipeList.count, 2)
        XCTAssertEqual(sut.recipeList[0].name, "Apam Balik")
        XCTAssertEqual(sut.recipeList[1].name, "Apple & Blackberry Crumble")
    }
    
    
}
