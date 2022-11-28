//
//  DataLoadOperation.swift
//  FindFriends
//
//  Created by Quan Tran on 25/10/2022.
//
import Foundation
import UIKit

class DataPrefetchOperation: Operation {

    let imageUrl: String
    
    init(with url:String) {
        self.imageUrl = url
    }
    
    override func main() {
        if isCancelled { return }
            // fire a download
        ImageFetcherHelper.loadImage(with: self.imageUrl)
    }
}

struct ImageFetcherHelper {
    static func loadImage(with url: String) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image:", err)
                return
            }
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            imageCache[url.absoluteString] = photoImage
        }.resume()
    }
}
