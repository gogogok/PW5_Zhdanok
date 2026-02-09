//
//  Article.swift
//  PW5_Zhdanok
//
//  Created by Дарья Жданок on 9.02.26.
//
import UIKit

struct ArticleModel: Decodable {
    let newsId: Int?
    let title: String?
    let announce: String?
    let img: ImageContainer?
}

struct ImageContainer: Decodable {
    let url: URL?
}

struct NewsPage: Decodable {
    let news: [ArticleModel]?
    let requestId: String?
    func articleUrl(for article: ArticleModel) -> URL? {
        guard let newsId = article.newsId else { return nil }
        let rid = requestId ?? ""
        return URL(string: "https://news.myseldon.com/ru/news/index/\(newsId)?requestId=\(rid)")
    }
}

struct Article {
    let title: String
    let description: String?
    let imageUrl: URL?
    let articleUrl: URL?
}
