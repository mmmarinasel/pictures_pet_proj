import Foundation

class PicturesViewModel {
    
    let searchBaseUrl: String = "https://api.unsplash.com/search/photos/?query="
    let token: String = "&client_id=sqTw7Hx4BF4a9nWcXzuXgmxg8BMwQXMxgrjlp0UFlos"
    
    let picturesUrl: String = "https://api.unsplash.com/photos/?client_id=sqTw7Hx4BF4a9nWcXzuXgmxg8BMwQXMxgrjlp0UFlos"
    
    var presentedItem: Observable<PictureData?> = Observable(nil)
    
    var picturesData: Observable<[PictureData]> = Observable([])
    var pictureCellViewModels: Observable<[PicCellViewModel]> = Observable([])
    
    init() {
        self.fetchData()
    }
    
    func getPicCellViewModel(_ indexPath: IndexPath) -> PicCellViewModel? {
        guard !(self.pictureCellViewModels.value?.isEmpty ?? true) else { return nil }
        return self.pictureCellViewModels.value?[indexPath.item]
    }
    
    private func setVMs() {
        var vms = [PicCellViewModel]()
        guard let picsData = self.picturesData.value else { return }
        for picData in picsData {
            vms.append(createPicCellViewModel(data: picData))
        }
        self.pictureCellViewModels.value = vms
    }
    
    private func createPicCellViewModel(data: PictureData) -> PicCellViewModel {
        let imageUrl = data.urls.small
        let descr = data.description ?? ""
        return PicCellViewModel(imageUrl: imageUrl, description: descr)
    }
    
    func handleTap(_ indexPath: IndexPath) {
        self.presentedItem.value = self.picturesData.value?[indexPath.item]
    }
    
    private func fetchData() {
        NetworkManager.getData(urlString: self.picturesUrl) { [weak self] picData in
            self?.picturesData.value? = picData
            self?.setVMs()
        }
    }
    
    func handleSearch(_ query: String) {
        if query.isEmpty {
            NetworkManager.getData(urlString: self.picturesUrl) { [weak self] picData in
                self?.picturesData.value? = picData
                self?.setVMs()
            }
        } else {
            let url = self.searchBaseUrl + query + self.token
            NetworkManager.getSingleData(urlString: url) { [weak self] (picData: PicturesFiltered) in
                self?.picturesData.value? = picData.results
                self?.setVMs()
            }
        }
        
    }
}
