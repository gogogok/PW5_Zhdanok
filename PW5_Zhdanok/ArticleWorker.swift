//
//  ArticleWorker.swift
//  PW5_Zhdanok
//
//  Created by Дарья Жданок on 9.02.26.
//

import UIKit

final class ArticleWorker {
    func fetchNews(page: Int, completion: @escaping (Result<[Article], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.4) {
            completion(.success([
                Article(title: "Demo article p\(page)-1", description: "Description"),
                Article(title: "Demo article p\(page)-2", description: nil)
            ]))
        }
    }
}
