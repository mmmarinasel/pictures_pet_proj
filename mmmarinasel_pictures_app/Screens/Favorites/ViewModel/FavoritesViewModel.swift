import Foundation

class FavoritesViewModel {
    
    var favorites: Observable<[FavoritesModel]> = Observable([])
    var favoriteCellViewModels: Observable<[FavoriteCellViewModel]> = Observable([])
    
    var presentedItem: Observable<PictureData?> = Observable(nil)
    
    let photoBaseUrl: String = "https://api.unsplash.com/photos/"
    let token: String = "?client_id=sqTw7Hx4BF4a9nWcXzuXgmxg8BMwQXMxgrjlp0UFlos"
    
    init() {
        refresh()
    }
    
    func getFavCellViewModel(_ indexPath: IndexPath) -> FavoriteCellViewModel? {
        guard !(favoriteCellViewModels.value?.isEmpty ?? true) else { return nil }
        return self.favoriteCellViewModels.value?[indexPath.row]
    }
    
    func setVMs() {
        var vms = [FavoriteCellViewModel]()
        guard let favsData = self.favorites.value else { return }
        for favData in favsData {
            vms.append(createFavCellViewModel(data: favData))
        }
        self.favoriteCellViewModels.value = vms
    }
    
    func createFavCellViewModel(data: FavoritesModel) -> FavoriteCellViewModel {
        let imageUrl = data.imageUrl
        let name = data.authorName
        return FavoriteCellViewModel(imageUrl: imageUrl, authorName: name)
    }
    
    func refresh() {
        let favs = DatabaseManager.shared.fetchItems()
        var urls = [String]()
        for fav in favs {
            let url = self.photoBaseUrl + fav.id + token
            urls.append(url)
        }
        self.favorites.value = []
        for url in urls {
            NetworkManager.getSingleData(urlString: url) { [weak self] (data: PictureData) in
                self?.favorites.value?.append(FavoritesModel(imageUrl: data.urls.thumb,
                                                             authorName: data.user.name,
                                                             id: data.id))
                if self?.favorites.value?.count == urls.count {
                    self?.setVMs()
                }
            }
        }
    }
    
    func handleTap(_ indexPath: IndexPath) {
        let url = self.photoBaseUrl + (self.favorites.value?[indexPath.row].id ?? "") + self.token
        NetworkManager.getSingleData(urlString: url) { [weak self] (data: PictureData) in
            self?.presentedItem.value = data
        }
    }
}
