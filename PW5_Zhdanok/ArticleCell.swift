import UIKit

final class ArticleCell: UITableViewCell {
    
    //MARK: - Constants
    enum Constants {
        static let articleImageViewTop: CGFloat = 20
        static let articleImageViewLeftRight: CGFloat = 50
        static let articleImageViewHeight: CGFloat = 180
        
        static let titleLabelFont: CGFloat = 18
        static let descriptionLabelTop: CGFloat = 20
    }
    
    //MARK: - Fields
    static let reuseId = "ArticleCell"
    private let articleImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private var currentImageURL: URL?
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        articleImageView.updateShimmerFrame()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentImageURL = nil
        articleImageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
    
    //MARK: - UI
    private func setupUI() {
        selectionStyle = .none
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        
        contentView.addSubview(articleImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        articleImageView.pinTop(to: contentView.topAnchor, Constants.articleImageViewTop)
        articleImageView.pinHorizontal(to: contentView, Constants.articleImageViewLeftRight)
        articleImageView.setHeight(Constants.articleImageViewHeight)
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        
        
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: Constants.titleLabelFont)
        titleLabel.pinTop(to: articleImageView.bottomAnchor)
        titleLabel.pinHorizontal(to: contentView, Constants.articleImageViewLeftRight)
        
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, Constants.descriptionLabelTop)
        descriptionLabel.pinHorizontal(to: contentView, Constants.articleImageViewLeftRight)
        descriptionLabel.pinBottom(to: contentView.bottomAnchor)
    }
    
    //MARK: - Configure cell
    func configure(title: String, description: String?, imageUrl: URL?) {
        titleLabel.text = title
        descriptionLabel.text = description
        articleImageView.image = nil
        guard let url = imageUrl else {
            articleImageView.stopShimmer()
            return
        }
        currentImageURL = url
        articleImageView.startShimmer()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                guard let self, self.currentImageURL == url else { return }
                self.articleImageView.image = image
                self.articleImageView.stopShimmer()
            }
        }
    }
}
