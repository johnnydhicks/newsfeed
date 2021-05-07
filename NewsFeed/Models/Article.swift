//
//  Article.swift
//  NewsFeed
//
//  Created by Johnny Hicks on 4/9/21.
//

import UIKit

final class Article: Decodable {
    enum ArticleKeys: String, CodingKey {
        case id
        case title
        case createdAt = "created_at"
        case source
        case description
        case favorite
        case heroImage = "hero_image"
        case link
    }
    
    var id: Int
    var title: String
    var createdAt: Date
    var source: String
    var description: String
    var favorite: Bool
    var heroImage: URL
    var link: URL
    var articleImage: UIImage?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArticleKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.source = try container.decode(String.self, forKey: .source)
        self.description = try container.decode(String.self, forKey: .description)
        self.favorite = try container.decode(Bool.self, forKey: .favorite)
        self.heroImage = try container.decode(URL.self, forKey: .heroImage)
        self.link = try container.decode(URL.self, forKey: .link)
    }
}

struct NewsFeed: Decodable {
    var articles: [Article]
}
