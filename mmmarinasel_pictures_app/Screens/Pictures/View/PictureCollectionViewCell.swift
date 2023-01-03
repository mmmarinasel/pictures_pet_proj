import UIKit

class PictureCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    static var id: String = "pictureCell"
    
    var cellViewModel: PicCellViewModel? {
        didSet {
            self.imageView.image = UIImage(systemName: "photo")
            NetworkManager.loadImageByUrl(urlString: cellViewModel?.imageUrl) { [weak self] img in
                self?.imageView.image = img
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addImageView() {
        self.addSubview(self.imageView)
        self.imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}
