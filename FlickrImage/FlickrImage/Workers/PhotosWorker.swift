//
//  PhotosWorker.swift
//  FlickrImage
//
//  Created by Deniz Tav on 29/08/2019.
//  Copyright © 2019 Deniz Tav. All rights reserved.
//

import UIKit

public class PhotosWorker {
    var photosStore: PhotosStoreProtocol
    var text = ""
    
    init(photosStore: PhotosStoreProtocol) {
        self.photosStore = photosStore
    }
    
    func fetchPhotos(completionHandler: @escaping ([Photo]?) -> Void) {
        photosStore.fetchPhotos(text: text) { photos -> Void in
            if photos != nil {
                DispatchQueue.main.async {
                    completionHandler(photos?.photos.photo)
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler([])
                }
            }
        }
    }
}
protocol PhotosStoreProtocol {
    func fetchPhotos(text: String, completionHandler: @escaping (PhotosResponse?) -> Void)
}
