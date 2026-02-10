import UIKit

final class NewsInteractor: NewsBusinessLogic, NewsDataStore {

    var articles: [Article] = [] {
        didSet {
            presenter?.presentNews(.init(articles: articles, isFresh: true))
        }
    }
    
    //MARK: - Fields

    private let worker: ArticleWorker
    var presenter: NewsPresentationLogic?
    private var page: Int = 1
    private var isLoading = false

    //MARK: - Init
    init(presenter: NewsPresenter, worker: ArticleWorker = ArticleWorker()) {
        self.presenter = presenter
        self.worker = worker
    }

    //MARK: - Func
    func loadFreshNews() {
        guard !isLoading else { return }
        isLoading = true
        page = 1

        worker.fetchNews(page: page) { [weak self] result in
            guard let self else { return }
            self.isLoading = false

            switch result {
            case .success(let newArticles):
                self.articles = newArticles
            case .failure:
                break
            }
        }
    }

    func loadMoreNews() {
        guard !isLoading else { return }
        isLoading = true
        page += 1

        worker.fetchNews(page: page) { [weak self] result in
            guard let self else { return }
            self.isLoading = false

            switch result {
            case .success(let more):
                self.articles += more
            case .failure:
                self.page -= 1
            }
        }
    }
}
