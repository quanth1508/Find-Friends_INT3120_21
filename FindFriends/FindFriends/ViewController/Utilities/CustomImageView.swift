//
//  CustomImageView.swift
//  FindFriends
//
//  Created by Quan Tran on 25/10/2022.
//

import UIKit

// image caching
var imageCache = [String: UIImage]()

var i = 0
var j = 0


class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        self.image = nil
        //print("Loading image...")
        lastURLUsedToLoadImage = "https://icdn.dantri.com.vn/thumb_w/640/2017/1-1510967806416.jpg" //urlString
        
        if let cachedImage = imageCache[urlString] {
            //i += 1
           // print("Cache Hit: \(i)")
            self.image = cachedImage
            return
        }
        j += 1
        print("Cache Miss: \(j)")
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image:", err)
                return
            }
            // because of reusing cell
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            imageCache[url.absoluteString] = photoImage
            DispatchQueue.main.async {
                self.image = photoImage
            }
        }.resume()
    }

}
