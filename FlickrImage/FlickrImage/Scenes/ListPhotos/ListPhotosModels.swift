//
//  ListPhotosModels.swift
//  FlickrImage
//
//  Created by Deniz Tav on 29/08/2019.
//  Copyright © 2019 Deniz Tav. All rights reserved.
//

import Foundation

enum ListPhotosModels {
    
    // MARK: Use cases
    enum FetchPhotos {
        struct Request {
            var text: String
        }
        struct Response {
            var photos: [Photo]
        }
        struct ViewModel {
            struct DisplayedPhoto {
                var image: String?
                var name: String?
            }
            var displayedPhotos: [DisplayedPhoto]
        }
    }
}
