import UIKit

class FavoritePictureTableViewCell: UITableViewCell {
    
    private lazy var favImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    var cellViewModel: FavoriteCellViewModel? {
        didSet {
            self.favImageView.image = UIImage(systemName: "photo")
            NetworkManager.loadImageByUrl(urlString: cellViewModel?.imageUrl) { [weak self] img in
                self?.favImageView.image = img
            }
            self.authorNameLabel.text = cellViewModel?.authorName
        }
    }

    static let id: String = "favCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.removeSubviews()
        self.setup()
    }
    
    private func removeSubviews() {
        self.favImageView.removeFromSuperview()
        self.authorNameLabel.removeFromSuperview()
    }
    
    private func setup() {
        self.contentView.addSubview(self.favImageView)
        self.contentView.addSubview(self.authorNameLabel)
        
        let constraints = [
            self.favImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.favImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                    constant: 15),
            self.favImageView.heightAnchor.constraint(equalToConstant: 80),
            self.favImageView.widthAnchor.constraint(equalToConstant: 80),
            self.authorNameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.authorNameLabel.leadingAnchor.constraint(equalTo: self.favImageView.trailingAnchor,
                                                          constant: 15),
            self.authorNameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                                                           constant: -15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
