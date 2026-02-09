import UIKit

final class ArticleCell: UITableViewCell {
    static let reuseId = "ArticleCell"

    private let articleImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    private var currentImageURL: URL?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        selectionStyle = .none
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0

        contentView.addSubview(articleImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)

        articleImageView.pinTop(to: contentView.topAnchor, 20)
        articleImageView.pinHorizontal(to: contentView, 50)
        articleImageView.setHeight(180)
    
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.pinTop(to: articleImageView.bottomAnchor)
        titleLabel.pinHorizontal(to: contentView, 50)
        
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, 20)
        descriptionLabel.pinHorizontal(to: contentView, 50)
        descriptionLabel.pinBottom(to: contentView.bottomAnchor)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        currentImageURL = nil
        articleImageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
    }

    func configure(title: String, description: String?, imageUrl: URL?) {
        titleLabel.text = title
        descriptionLabel.text = description
        articleImageView.image = nil

        guard let url = imageUrl else { return }
        currentImageURL = url

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                guard let self, self.currentImageURL == url else { return }
                self.articleImageView.image = image
            }
        }
    }
}
