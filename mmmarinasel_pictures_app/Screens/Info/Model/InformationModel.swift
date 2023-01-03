import Foundation
import UIKit.UIImage

struct InformationModel {
    var image: UIImage
    let authorName: String
    let date: String
    let location: String
    let downloadCount: String
    let id: String
    var isFav: Observable<Bool>
}
