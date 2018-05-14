import Alamofire

let flickrApi    =  "https://api.flickr.com/services/rest"
let flickrMethod =  "flickr.photos.search"
let apiKeyValue  =  "739b660ea3629666d04b83ad0a19a381"
let limit        =  20

class PhotoManager {
    
    static func searchPhotos(forQuery searchText: String, page: Int, completion: @escaping (_ photos: [Photo])->Void) -> Void {
        
        guard let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        let parameters : [String: Any] = [
            "method":          flickrMethod,
            "api_key":             apiKeyValue,
            "nojsoncallback":  "1",
            "format":          "json",
            "safe_search":      "1",
            "text":            encodedText,
            "per_page":         limit,
            "page":            page
        ]
        
        Alamofire.request(flickrApi, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            guard let results = response.result.value as? [String: Any],
                  let photosDict = results["photos"] as? [String: Any],
                  let photosArray = photosDict["photo"] as? [[String:Any]]
            else { return }
            
            completion(photosArray.map({ Photo(with: $0) }))
            
        }
    }
}
