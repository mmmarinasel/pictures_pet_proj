import UIKit

class InformationViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var authorNameLabel: UILabel = {
        return self.createLabel(font: UIFont.systemFont(ofSize: 22, weight: .medium))
    }()
    
    private lazy var dateLabel: UILabel = {
        return self.createLabel(font: UIFont.systemFont(ofSize: 15, weight: .regular))
    }()

    private lazy var locationLabel: UILabel = {
        return self.createLabel(font: UIFont.systemFont(ofSize: 15, weight: .medium))
    }()
    
    private lazy var downloadCountLabel: UILabel = {
        return self.createLabel(font: UIFont.systemFont(ofSize: 13, weight: .regular))
    }()
    
    private lazy var addToFavsButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "rays"), for: .normal)
        button.tintColor = .red
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(favButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var viewModel: InformationViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        self.viewModel?.info.bind { [weak self] data in
            guard let info = data as? InformationModel else { return }
            self?.imageView.image = info.image
            self?.authorNameLabel.text = info.authorName
            self?.locationLabel.text = info.location
            self?.dateLabel.text = info.date
            self?.downloadCountLabel.text = info.downloadCount
        }
        
        self.viewModel?.info.value??.isFav.bind { [weak self] isFav in
            guard let isFav = isFav else { return }
            if isFav {
                self?.addToFavsButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                self?.addToFavsButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
    }
    
    private func setup() {
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.addToFavsButton)
        self.view.addSubview(self.authorNameLabel)
        self.view.addSubview(self.dateLabel)
        self.view.addSubview(self.locationLabel)
        self.view.addSubview(self.downloadCountLabel)
        
        let constraints = [
            self.backButton.topAnchor.constraint(equalTo: self.view.topAnchor,
                                                 constant: 50),
            self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                     constant: 30),
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.backButton.bottomAnchor,
                                                constant: 20),
            self.imageView.widthAnchor.constraint(equalToConstant: 240),
            self.imageView.heightAnchor.constraint(equalToConstant: 240),
            
            self.addToFavsButton.centerXAnchor.constraint(equalTo: self.imageView.trailingAnchor),
            self.addToFavsButton.centerYAnchor.constraint(equalTo: self.imageView.topAnchor),
            self.addToFavsButton.widthAnchor.constraint(equalToConstant: 40),
            self.addToFavsButton.heightAnchor.constraint(equalToConstant: 40),
            
            self.authorNameLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor,
                                                      constant: 15),
            self.authorNameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.authorNameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                          constant: 20),
            
            self.dateLabel.topAnchor.constraint(equalTo: self.authorNameLabel.bottomAnchor,
                                                      constant: 15),
            self.dateLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.dateLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                    constant: 20),
            
            self.locationLabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor,
                                                      constant: 15),
            self.locationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.locationLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                        constant: 20),
            
            self.downloadCountLabel.topAnchor.constraint(equalTo: self.locationLabel.bottomAnchor,
                                                      constant: 15),
            self.downloadCountLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.downloadCountLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                             constant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
        
        self.addToFavsButton.layer.cornerRadius = 25
    }
    
    private func createLabel(font: UIFont) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        
        return label
    }
    
    private func presentAlert(isFav: Bool) {
        var title: String = "Removed from favorites"
        if !isFav {
            title = "Added to favorites"
        }
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .destructive)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    @objc func favButtonTapped(sender: UIButton!) {
        let isFav = self.viewModel?.info.value??.isFav.value
        self.viewModel?.info.value??.isFav.value = !(isFav ?? true)
        guard let isFav = isFav else { return }
        if !isFav {
            let object = RealmFavoriteObject()
            object.id = self.viewModel?.info.value??.id ?? ""
            DatabaseManager.shared.add(items: [object])
            
        } else {
            DatabaseManager.shared.delete(id: self.viewModel?.info.value??.id ?? "")
            
        }
        presentAlert(isFav: isFav)
    }
    
    @objc func backButtonTapped(sender: UIButton!) {
        self.dismiss(animated: true)
    }
}
