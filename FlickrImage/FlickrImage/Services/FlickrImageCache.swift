//
//  FlickrImageCache.swift
//  FlickrImage
//
//  Created by Deniz Tav on 30/08/2019.
//  Copyright © 2019 Deniz Tav. All rights reserved.
//

import UIKit

fileprivate let errorStatusCode: Int = 2
fileprivate let minErrorStatusCode: Int = 2

public extension UIImageView {
    
    func loadImage(fromURL url: String) {
        guard let imageURL = URL(string: url) else {
            return
        }
        print(url)
        let cache =  URLCache.shared
        let request = URLRequest(url: imageURL)
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? errorStatusCode) < minErrorStatusCode, let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        DispatchQueue.main.async {
                            self.image = image
                        }
                    }
                }).resume()
            }
        }
    }
}
