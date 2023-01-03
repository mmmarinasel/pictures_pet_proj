import RealmSwift

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let realm = try! Realm()
    
    func delete(id: String) {
        let items = realm.objects(RealmFavoriteObject.self).filter("id == '\(id)'")
        try! realm.write {
            realm.delete(items)
        }
    }
    
    func add(items: [Object]) {
        try! realm.write {
            realm.add(items)
        }
    }
    
    func fetchItems() -> [RealmFavoriteObject] {
        return Array(realm.objects(RealmFavoriteObject.self))
    }
    
    func isAddedItem(_ id: String) -> Bool {
        let item = realm.objects(RealmFavoriteObject.self).filter("id == '\(id)'")
        return !item.isEmpty
    }
}
