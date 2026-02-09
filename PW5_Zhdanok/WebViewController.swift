//
//  WebViewController.swift
//  PW5_Zhdanok
//
//  Created by Дарья Жданок on 9.02.26.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {

    var url: URL?

    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(webView)
        webView.pinHorizontal(to: view)
        webView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        webView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)

        if let url {
            webView.load(URLRequest(url: url))
        }
    }
}
