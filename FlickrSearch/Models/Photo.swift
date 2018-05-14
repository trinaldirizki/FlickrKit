class Photo {
    
    var id: String?
    var farm: Int?
    var server: String?
    var secret: String?
    let size = "m"
    
    var url: String? {
        get {
            if let farm = farm, let server = server, let id = id, let secret = secret {
                return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
            }
            return nil
        }
    }
    
    init(with attributes: [String:Any]) {
        id = attributes["id"] as? String
        farm = attributes["farm"] as? Int
        server = attributes["server"] as? String
        secret = attributes["secret"] as? String
    }
}
