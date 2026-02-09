import UIKit

enum ClickerAssembly {
    static func build() -> UIViewController {
        let presenter: NewsPresenter = NewsPresenter()
        let interactor: NewsInteractor = NewsInteractor(presenter: presenter)
        
        let viewController: NewViewController = NewViewController(
            interactor: interactor
        )

        presenter.viewController = viewController

        return viewController
    }
}
