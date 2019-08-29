//
//  Photo.swift
//  FlickrImage
//
//  Created by Deniz Tav on 29/08/2019.
//  Copyright © 2019 Deniz Tav. All rights reserved.
//

import UIKit

public struct Photo: Codable {
    public var id: String
    public var secret: String
    public var server: String
    public var farm: Int
    public var title: String
    
    public func imageUrl() -> String {
        return "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
    }
}
