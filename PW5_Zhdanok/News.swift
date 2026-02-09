import UIKit

enum News {
    enum Load {
        struct Request {
            let page: Int
        }
        struct Response {
            let articles: [Article]
            let isFresh: Bool
        }
        struct ViewModel {
            let rows: [Row]
        }
    }

    struct Row {
        let title: String
        let subtitle: String?
    }
}


