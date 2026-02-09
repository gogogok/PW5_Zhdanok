//
//  ArticleWorker.swift
//  PW5_Zhdanok
//
//  Created by Дарья Жданок on 9.02.26.
//

import UIKit
import Foundation

final class ArticleWorker {
    enum Constants {
        static let rubricId = 4
        static let pageSize = 8
    }
    
    private let decoder: JSONDecoder = JSONDecoder()
    
    private func getURL(_ rubric: Int, _ pageSize: Int,_ pageIndex: Int) -> URL? {
        URL(string: "https://news.myseldon.com/api/Section?rubricId=\(rubric)&pageSize=\(pageSize)&pageIndex=\(pageIndex)")
    }
    
    func fetchNews(page: Int, completion: @escaping (Result<[Article], Error>) -> Void) {
        
        guard let url = getURL(Constants.rubricId, Constants.pageSize, page) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(
            with: url
        ) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard
                let http = response as? HTTPURLResponse,
                (200...299).contains(http.statusCode),
                let data
            else {
                DispatchQueue.main.async {
                    completion(.failure(URLError(.badServerResponse)))
                }
                return
            }
            
            do {
                let pageResponse = try JSONDecoder().decode(NewsPage.self, from: data)
                
                let articles: [Article] = (pageResponse.news ?? []).map { model in
                    Article(
                        title: model.title ?? "No title",
                        description: model.announce,
                        imageUrl: model.img?.url,
                        articleUrl: pageResponse.articleUrl(for: model)
                    )
                }
                
                DispatchQueue.main.async {
                    completion(.success(articles))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}

