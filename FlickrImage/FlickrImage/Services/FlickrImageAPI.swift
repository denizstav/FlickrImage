//
//  FlickrImageAPI.swift
//  FlickrImage
//
//  Created by Deniz Tav on 29/08/2019.
//  Copyright © 2019 Deniz Tav. All rights reserved.
//

import Foundation

public class FlickrImageAPI: PhotosStoreProtocol {
    let baseUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&text="
    var previosText = ""
    var page = 1
    
    func fetchPhotos(text: String, completionHandler: @escaping (FlickerResponse?) -> Void) {
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
