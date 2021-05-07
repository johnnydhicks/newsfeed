//
//  NewsFeedController.swift
//  NewsFeed
//
//  Created by Johnny Hicks on 4/9/21.
//

import UIKit

class NewsFeedController {
    
    private(set) var articles: [Article] = []
    
    var filteredArticles: [Article] {
        let shouldFilter = UserDefaults.standard.bool(forKey: .shouldFilterArticles)
        if shouldFilter {
            return articles.filter( { $0.favorite })
        } else {
            return articles
        }
    }
    
    init() {
       decodeArticles()
    }
    
    func decodeArticles() {
        if let path = Bundle.main.path(forResource: "articles", ofType: "json") {
            do {
              let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let articles = try decoder.decode(NewsFeed.self, from: data).articles
                self.articles = articles
            } catch {
                NSLog("Unable to decode JSON data: \(error)")
            }
        }
    }
    
    func fetchImageForArticle(article: Article, completion: @escaping () -> ()) {
        guard article.articleImage == nil else { completion(); return }
        let url = article.heroImage
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                NSLog("Error fetching hero image for article: \(article.title) with error: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data received")
                completion()
                return
            }
            
            article.articleImage = UIImage(data: data)
            completion()
        }.resume()
    }
}
