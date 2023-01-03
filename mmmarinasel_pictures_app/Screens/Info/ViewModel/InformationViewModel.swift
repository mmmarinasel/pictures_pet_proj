import Foundation
import UIKit

class InformationViewModel {
    
    var info: Observable<InformationModel?> = Observable(nil)
    
    init(_ pictureData: PictureData?) {
        guard let data = pictureData else { return }
        let date = convertDateFormat(dateStr: data.date)
        self.info.value = InformationModel(image: UIImage(systemName: "photo") ?? UIImage(),
                                           authorName: data.user.name,
                                           date: date,
                                           location: data.user.location ?? "unknown location",
                                           downloadCount: "\(data.likes) likes",
                                           id: data.id,
                                           isFav: Observable(false))
        NetworkManager.loadImageByUrl(urlString: data.urls.small) { [weak self] img in
            self?.info.value??.image = img
        }
        guard let id = self.info.value??.id else { return }
        if DatabaseManager.shared.isAddedItem(id) {
            self.info.value??.isFav.value = true
        }
    }
    
    func convertDateFormat(dateStr: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = formatter.date(from: dateStr)
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date ?? Date.now)
    }
}
