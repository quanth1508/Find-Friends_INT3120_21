//
//  SharePhotoController.swift
//  FindFriends
//
//  Created by Quan Tran on 25/10/2022.
//

import UIKit
import Then
import PromiseKit


class SharePhotoController: UIViewController {

    var selectedImage: UIImage? {
        didSet {
            imageView.image = selectedImage
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private let service = SharePostService()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(handleShare))
        setupViews()
    }
    
    // update HomeFeed
    static let updateFeedNotificationName = Notification.Name(rawValue: "UpdateFeed")
    
    @objc private func handleShare() {
        guard let caption = textView.text, !caption.isEmpty else { return }
        guard let image = selectedImage else { return }
        guard let uploadData = image.jpegData(compressionQuality: 0.2) else { return }
        navigationItem.rightBarButtonItem?.isEnabled = false
        saveToDatabaseWithImageUrl(imageUrl: "")
    }

    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let postImage = selectedImage else { return }
        guard let caption = textView.text else { return }
        
        firstly {
            service.createNewPost(post: Post().with {
                $0.caption = caption
                $0.imageUrl = "https://images.unsplash.com/photo-1585409677983-0f6c41ca9c3b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2938&q=80"
            })
        }
        .done { [weak self] in
            guard let self = self else { return }
            AlertHelper.showAlert(message: "Bạn đã tạo bài viết thành công", from: self, cancelCompletion:  { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
            })
        }
        .catch { [weak self] error in
            guard let self = self else { return }
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            AlertHelper.showAlert(message: error.localizedDescription, from: self)
        }
    }

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .secondarySystemBackground
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()

    private func setupViews() {
        let containerView = UIView()
        containerView.backgroundColor = .secondarySystemBackground
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)

        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)

        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }

}
