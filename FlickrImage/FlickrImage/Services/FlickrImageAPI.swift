//
//  FlickrImageAPI.swift
//  FlickrImage
//
//  Created by Deniz Tav on 29/08/2019.
//  Copyright © 2019 Deniz Tav. All rights reserved.
//

import Foundation

public class FlickrImageAPI: PhotosStoreProtocol {
    let apiKey: String
    let baseUrl: String
    var previosText: String
    var page: Int
    
    init() {
        apiKey = "3e7cc266ae2b0e0d78e279ce8e361736"
        baseUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&format=json&nojsoncallback=1&safe_search=1&text="
        previosText = ""
        page = 1
    }
    
    func fetchPhotos(text: String, completionHandler: @escaping (PhotosResponse?) -> Void) {
        if previosText != text {
            previosText = text
            page = 1
        } else {
            page += 1
        }
        let urlString = "\(baseUrl)\(text)&page=\(page)"
        fetch(
            url: urlString,
            completion: completionHandler
        )
    }
    
    func fetch<T: Codable>(url: String, completion: @escaping (T?) -> Void) {
        guard let url = URL(string: url)
            else {
                return completion(nil)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard
                let data = data,
                let obj = try? JSONDecoder().decode(T.self, from: data)
                else {
                    return completion(nil)
            }
            completion(obj)
        }
        task.resume()
    }
}
