//
//  HomeController.swift
//  FindFriends
//
//  Created by Quan Tran on 25/10/2022.
//

import UIKit
import PromiseKit


class HomeController: UICollectionViewController, HomePostCellDelegate {
    
    var user:User?
    let cellId = "cellId"
    var posts = [Post]()
    let refreshControl = UIRefreshControl()
    
    let loadingPhotosQueue = OperationQueue()
    var loadingPhotosOperations: [IndexPath: DataPrefetchOperation] = [:]
    
    // paginations properties
    var fetchingMore = false
    var endReached = false
    let leadingScreenForBatching:CGFloat = 2
    
    private let homeService = HomeService()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.prefetchDataSource = self
        collectionView?.backgroundColor = .systemBackground
        collectionView?.register(HomePostCell.self,
                                 forCellWithReuseIdentifier: cellId)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleUpdateFeed),
                                               name: SharePhotoController.updateFeedNotificationName,
                                               object: nil)
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        setupDMbarbuttomItem()
        setupNavigationItems()
        fetchUser()
        fetchFeedPosts()
    }
    
    private func fetchUser() {
        self.navigationItem.title = FFUser.shared.name
    }
    
    private func setupDMbarbuttomItem () {
        let button = UIBarButtonItem(image: UIImage(systemName: "paperplane")?.withTintColor(.label, renderingMode: .alwaysOriginal),
                                     style: .plain,
                                     target: self,
                                     action: #selector(showDMController))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc
    private func showDMController() {
        guard let user = self.user else { return }
        let DMTVC = DMtableViewController()
        DMTVC.user = user
        DMTVC.navigationItem.title = "Direct"
        DMTVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(DMTVC, animated: true)
    }
    
    
    private var startKey:String?
    
    private func fetchFeedPosts() {
        fetchingMore = true
        firstly {
            homeService.fetchMyPost()
        }
        .ensure { [weak self] in
            guard let self = self else { return }
            self.fetchingMore = false
            self.collectionView?.refreshControl?.endRefreshing()
        }
        .done { [weak self] posts in
            guard let self = self else { return }
            self.posts.append(contentsOf: posts)
            self.endReached = posts.count == 0
            print(self.posts.count)
            self.collectionView.reloadData()
        }
        .catch { [weak self] error in
            guard let self = self else { return }
            error.showAlert(from: self)
        }
    }
    
    @objc func handleUpdateFeed() {
        refresh()
    }

    @objc func refresh() {
        posts.removeAll()
        fetchFeedPosts()
    }
    
    
    func setupNavigationItems() {
        let imageView = UIImageView(image: UIImage(named: "logo2"))
        navigationItem.titleView = imageView
    }
    
    
    // MARK:- ScrollViewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height * leadingScreenForBatching {
            if !fetchingMore && !endReached {
                fetchFeedPosts()
            }
        }
        print(posts.count)
    }
}

// MARK:- UICollectionViewDelegateFlowLayout

extension HomeController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let commentString = posts[indexPath.item].caption
        let estimateHeight = commentString.getEdtimatedHeight(width: view.frame.width)
        var height: CGFloat = 40 + 8 + 8 //username and userProfileImageView
        height += view.frame.width
        height += 50
        height += 60
        height += estimateHeight
        return CGSize(width: view.frame.width, height: height)
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                      for: indexPath) as! HomePostCell
        if !self.refreshControl.isRefreshing {
            cell.post = posts[indexPath.item]
            
            // TODO: what if operation queue and customImage.load doesn't fetch => we left with two request!
            
        }
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didEndDisplaying cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        if let dataLoader = loadingPhotosOperations[indexPath] {
            loadingPhotosOperations.removeValue(forKey: indexPath)
            dataLoader.cancel()
        }
    }
    
    func didTapComment(post: Post) {
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        commentsController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    func didLike(for cell: HomePostCell) {
    }

}


// MARK:- UICollectionViewDataSourcePrefetching

extension HomeController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {
        if !self.refreshControl.isRefreshing {
            for indexPath in indexPaths {
                let imageUrl = posts[indexPath.row].imageUrl
                if imageCache[imageUrl] == nil {
                    //print("loading indexpath: \(indexPath)")
                    let dataPrefetcher = DataPrefetchOperation(with: imageUrl)
                    loadingPhotosQueue.addOperation(dataPrefetcher)
                    loadingPhotosOperations[indexPath] = dataPrefetcher
                }
            }
        }
    }

    // it's only called when the cache is cleared as the photos
    func collectionView(_ collectionView: UICollectionView,
                        cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let dataPrefetcher = loadingPhotosOperations[indexPath] {
                dataPrefetcher.cancel()
                loadingPhotosOperations.removeValue(forKey: indexPath)
                //print("cancel loading indexpath: \(indexPath)")
            }
        }
    }
}

