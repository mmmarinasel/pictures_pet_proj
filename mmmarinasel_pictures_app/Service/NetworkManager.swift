import Foundation
import UIKit.UIImage

protocol NetworkManagerProtocol {
    static func getData<T: Codable>(urlString: String, completion: @escaping ([T]) -> Void)
    static func getSingleData<T: Codable>(urlString: String, completion: @escaping (T) -> Void)
}

protocol PictureLoaderProtocol {
    static func loadImageByUrl(urlString: String?, completion: @escaping (UIImage) -> Void)
}

class NetworkManager: NetworkManagerProtocol, PictureLoaderProtocol {
    
    private static func getJson(urlString: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    static func getData<T: Codable>(urlString: String, completion: @escaping ([T]) -> Void) {
        NetworkManager.getJson(urlString: urlString) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            
            do {
                let json = try JSONDecoder().decode([T].self, from: data)
                DispatchQueue.main.async {
                    completion(json)
                }
                
            } catch {
                print(error.localizedDescription)
                print(error)
            }
        }
    }
    
    static func getSingleData<T: Codable>(urlString: String, completion: @escaping (T) -> Void) {
        NetworkManager.getJson(urlString: urlString) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            
            do {
                let json = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(json)
                }
            } catch {
                print(error.localizedDescription)
                print(error)
            }
        }
    }
    
    static func loadImageByUrl(urlString: String?, completion: @escaping (UIImage) -> Void) {
        guard let urlString = urlString else { return }
        DispatchQueue.global().async {
            if let url = URL(string: urlString),
               let imageData = try? Data(contentsOf: url),
               let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
}
