//
//  UserSearchController.swift
//  FindFriends
//
//  Created by Quan Tran on 25/10/2022.
//

import UIKit


class UserSearchController: UICollectionViewController {
    
    let cellId = "cellId"
    var filteredUsers = [User]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .systemBackground
        navigationItem.titleView = searchBar
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag
        fetchUsers()
    }
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        sb.barTintColor = .gray
        sb.delegate = self
        return sb
    }()
   
    
    fileprivate func fetchUsers() {
//        let ref = Database.database().reference().child("users")
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//             guard let dictionaries = snapshot.value as? [String: Any] else { return }
//             dictionaries.forEach({ (key, value) in
//                 if key == Auth.auth().currentUser?.uid {
//                    return
//                }
//                guard let userDictionary = value as? [String: Any] else { return }
//                let user = User(uid: key, dictionary: userDictionary)
//                self.users.append(user)
//            })
//            self.users.sort(by: { (user1, user2) -> Bool in
//                return user1.username.compare(user2.username) == .orderedAscending
//            })
//            self.filteredUsers = self.users
//         }) { (err) in
//            print("Failed to fetch users for search:", err)
//        }
    }
}

extension UserSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter { (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        self.collectionView?.reloadData()
    }
}

extension UserSearchController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        cell.user = filteredUsers[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        var user = filteredUsers[indexPath.item]
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        user.profileImageUrl = "https://www.google.com/imgres?imgurl=https%3A%2F%2Ficdn.dantri.com.vn%2Fthumb_w%2F640%2F2017%2F1-1510967806416.jpg&imgrefurl=https%3A%2F%2Fdantri.com.vn%2Fsuc-manh-so%2Fbo-anh-chup-bang-dien-thoai-nhung-dep-den-ngo-ngang-2017111808281281.htm&tbnid=bIveYLJfYn9jyM&vet=12ahUKEwiT64mB0b77AhWLG6YKHYZFCT0QMygdegUIARD6AQ..i&docid=H4IiSGMwSKkXUM&w=640&h=853&q=%E1%BA%A3nh%20%C4%91%E1%BA%B9p&ved=2ahUKEwiT64mB0b77AhWLG6YKHYZFCT0QMygdegUIARD6AQ"
        userProfileController.user = user
        userProfileController.userId = user.uid
        navigationController?.pushViewController(userProfileController, animated: true)
    }
}


