import UIKit

final class NewsPresenter: NewsPresentationLogic {
    
    weak var viewController: NewViewController?
    
    func presentNews(_ response: News.Load.Response) {
        let rows = response.articles.map {
            News.Row(title: $0.title, subtitle: $0.description)
        }
        viewController?.displayNews(.init(rows: rows))
    }
}
