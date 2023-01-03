import UIKit

class PicturesViewController: UIViewController {

    private lazy var searchTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Search a photo by a key word"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(searchPics), for: .editingChanged)
        return textField
    }()

    private var picturesCollectionView: UICollectionView?
    private var viewModel = PicturesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(self.searchTextField)
        self.picturesCollectionView = UICollectionView(frame: self.view.frame,
                                                       collectionViewLayout: self.createLayout())
        guard let picturesCollectionView = self.picturesCollectionView else { return }
        picturesCollectionView.delegate = self
        picturesCollectionView.dataSource = self
        picturesCollectionView.register(PictureCollectionViewCell.self,
                                             forCellWithReuseIdentifier: PictureCollectionViewCell.id)
        self.view.addSubview(picturesCollectionView)
        
        self.viewModel.pictureCellViewModels.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.picturesCollectionView?.reloadData()
            }
        }
 
        self.viewModel.presentedItem.bind { [weak self] data in
            let vc = InformationViewController()
            vc.modalPresentationStyle = .fullScreen
            guard let data = data else { return }
            vc.viewModel = InformationViewModel(data)
            self?.present(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
        
    }
    
    private func setup() {

        guard let picturesCollectionView = self.picturesCollectionView else { return }
        
        self.searchTextField.translatesAutoresizingMaskIntoConstraints = false
        picturesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.searchTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                          constant: 20),
            self.searchTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.searchTextField.topAnchor.constraint(equalTo: self.view.topAnchor,
                                                      constant: 50),
            picturesCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            picturesCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            picturesCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            picturesCollectionView.topAnchor.constraint(equalTo: self.searchTextField.bottomAnchor,
                                                             constant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
        self.searchTextField.delegate = self
    }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let size = self.view.frame.width / 2 - 20
        layout.itemSize = CGSize(width: size, height: size)
        return layout
    }
    
    @objc func searchPics(textField: UITextField) {
        self.viewModel.handleSearch(textField.text ?? "")
    }
}

extension PicturesViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

extension PicturesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.pictureCellViewModels.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCollectionViewCell.id, for: indexPath) as? PictureCollectionViewCell
        else { return UICollectionViewCell() }
        let cellVM = self.viewModel.getPicCellViewModel(indexPath)
        cell.cellViewModel = cellVM
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.viewModel.handleTap(indexPath)
    }
}

