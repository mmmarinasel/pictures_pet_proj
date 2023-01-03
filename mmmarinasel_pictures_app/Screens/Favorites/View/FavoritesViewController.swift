import UIKit

class FavoritesViewController: UIViewController {

    let favoritesTableView = UITableView()
    private let cellHeight: CGFloat = 100
    
    private var viewModel = FavoritesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(self.favoritesTableView)
        
        self.favoritesTableView.delegate = self
        self.favoritesTableView.dataSource = self
        self.favoritesTableView.register(FavoritePictureTableViewCell.self,
                                         forCellReuseIdentifier: FavoritePictureTableViewCell.id)
        
        self.viewModel.favoriteCellViewModels.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.favoritesTableView.reloadData()
            }
        }
        
        self.viewModel.presentedItem.bind { [weak self] data in
            DispatchQueue.main.async {
                let vc = InformationViewController()
                vc.modalPresentationStyle = .fullScreen
                guard let data = data else { return }
                vc.viewModel = InformationViewModel(data)
                self?.present(vc, animated: true)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setup()
        self.viewModel.refresh()
    }
    
    private func setup() {
        self.favoritesTableView.translatesAutoresizingMaskIntoConstraints = false
        self.favoritesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.favoritesTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.favoritesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.favoritesTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.favoriteCellViewModels.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritePictureTableViewCell.id) as? FavoritePictureTableViewCell
        else { return UITableViewCell() }
        let cellVM = self.viewModel.getFavCellViewModel(indexPath)
        cell.cellViewModel = cellVM
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.handleTap(indexPath)
    }
}
