import UIKit

final class NewsPresenter: NewsPresentationLogic {
    
    weak var viewController: NewViewController?
    
    func presentNews(_ response: News.Load.Response) {
        let rows = response.articles.map {
            News.Row(
                title: $0.title,
                subtitle: $0.description,
                imageUrl: $0.imageUrl,
                articleUrl: $0.articleUrl
            )
        }
        let vm = News.Load.ViewModel(rows: rows)
        viewController?.displayNews(vm)
    }
}
