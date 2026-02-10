//
//  NewViewComtroller.swift
//  PW5_Zhdanok
//
//  Created by Дарья Жданок on 9.02.26.
//

import UIKit

class NewViewController: UIViewController {
    
    
    let interactor: NewsInteractor
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var rows: [News.Row] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupTableView()
        interactor.loadFreshNews()
    }
    
    init(interactor: NewsInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinLeft(to: view.leadingAnchor)
        tableView.pinRight(to: view.trailingAnchor)
        tableView.pinBottom(to: view.bottomAnchor)
        
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseId)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func displayNews(_ viewModel: News.Load.ViewModel) {
        rows = viewModel.rows
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func shareNews(url: URL?) {
        guard let url = url else { return }
        let activityVC = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        
        present(activityVC, animated: true)
    }
    
}

extension NewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseId, for: indexPath) as! ArticleCell
        cell.configure(title: row.title, description: row.subtitle, imageUrl: row.imageUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Share") { [weak self] (action, view, completionHandler) in
            let row = self?.rows[indexPath.row]
            self?.shareNews(url: row?.articleUrl)
            completionHandler(true)
        }
        action.backgroundColor = UIColor.systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension NewViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 1.5 {
            interactor.loadMoreNews()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < interactor.articles.count else { return }
        guard let url = interactor.articles[indexPath.row].articleUrl else { return }
        let vc = WebViewController()
        vc.url = url
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
