import UIKit
import SVProgressHUD

let numberOfRows = 3

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var photosCollectionView: UICollectionView?
    
    var photos = [Photo]()
    var currentPage: Int = 0
    var searchText: String?
}

extension PhotosViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Flickr Search"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func searchPhotos(completion: ((_ success: Bool) -> Void)?) -> Void {
        guard let searchText = searchText else { return }
        PhotoManager.searchPhotos(forQuery: searchText, page: currentPage, completion: { [weak self] photos in
            SVProgressHUD.dismiss()
            if self?.currentPage == 0 {
                self?.photos.removeAll()
            }
            self?.photos.append(contentsOf: photos)
            if self?.currentPage == 0 {
                self?.photosCollectionView?.reloadData()
            } else {
                self?.insertPhotos()
            }
            completion?(true)
        })
    }
    
    func insertPhotos()  {
        
        var indexPaths = [IndexPath]()
        for i in  limit * currentPage..<photos.count {
            let indexPath = IndexPath(item: i, section: 0)
            indexPaths.append(indexPath)
        }
        
        photosCollectionView?.insertItems(at: indexPaths)
    }
    
    func prepareViewForSearch(with text: String?) -> Void {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
        searchText = text
        currentPage = 0
    }

}


extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell
            else { return UICollectionViewCell() }
        
        cell.setUp(with: photos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "searchReusableView", for: indexPath)
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (photos.count - 4) {
            currentPage += 1
            searchPhotos(completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfRows - 1))
            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfRows))
            return CGSize(width: size, height: size)
        } else {
            return CGSize(width: 90, height: 90)
        }
    }
}

extension PhotosViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        prepareViewForSearch(with: searchBar.text)
        searchPhotos(completion: { success in
            if success {
                searchBar.text = nil
            }
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
