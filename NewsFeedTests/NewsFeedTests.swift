//
//  NewsFeedTests.swift
//  NewsFeed
//
//  Created by Nick Donaldson on 3/28/19.
//  Copyright © 2019 BetterUp. All rights reserved.
//

import XCTest
@testable import NewsFeed

class NewsFeedTests: XCTestCase {

    func testJSONDecoder() {
        let controller = NewsFeedController()
        controller.decodeArticles()
        XCTAssertEqual(controller.articles.count, 5)
    }
    
    func testArticleFiltering() {
        let controller = NewsFeedController()
        controller.decodeArticles()
        
        UserDefaults.standard.setValue(true, forKey: .shouldFilterArticles)
        XCTAssertEqual(controller.filteredArticles.count, 2)
        
        UserDefaults.standard.setValue(false, forKey: .shouldFilterArticles)
        XCTAssertEqual(controller.filteredArticles.count, 5)
    }
    
    func testFetchImage() {
        let controller = NewsFeedController()
        controller.decodeArticles()
        let expectation = XCTestExpectation(description: "Waiting for image fetch")
        if let article = controller.articles.first {
            controller.fetchImageForArticle(article: article) {
                XCTAssertNotNil(article.articleImage)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 5)
        }
    }
}
