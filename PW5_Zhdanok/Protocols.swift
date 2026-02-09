import UIKit

protocol NewsBusinessLogic: AnyObject {
    func loadFreshNews()
    func loadMoreNews()
}

protocol NewsDataStore: AnyObject {
    var articles: [Article] { get set }
}

protocol NewsPresentationLogic: AnyObject {
    func presentNews(_ response: News.Load.Response)
}

protocol NewsDisplayLogic: AnyObject {
    func displayNews(_ viewModel: News.Load.ViewModel)
}

