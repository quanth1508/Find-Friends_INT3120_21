//
//  UserProfilePhotoCell.swift
//  FindFriends
//
//  Created by Quan Tran on 25/10/2022.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    var post: Post? {
        didSet {
            photoImageView.loadImage(urlString: post?.imageUrl ?? "")
        }
    }

    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .tertiarySystemBackground
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    private func sharedInit() {
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
