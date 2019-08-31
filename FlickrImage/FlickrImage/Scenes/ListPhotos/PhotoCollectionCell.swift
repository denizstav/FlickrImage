//
//  PhotoCollectionCell.swift
//  FlickrImage
//
//  Created by Deniz Tav on 29/08/2019.
//  Copyright © 2019 Deniz Tav. All rights reserved.
//

import UIKit

final class PhotoCollectionCell: UICollectionViewCell {
    
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    fileprivate let cellCornerRadius: CGFloat = 6.0

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = cellCornerRadius
        containerView.layer.masksToBounds = true
        imageView.layer.cornerRadius = cellCornerRadius
        imageView.layer.masksToBounds = true
        imageView.image = nil
    }
    
    var photo: ListPhotosModels.FetchPhotos.ViewModel.DisplayedPhoto? {
        didSet {
            imageView.image = nil
            if let photo = photo {
                guard let image = photo.image else {
                    return
                }
                imageView.loadImage(fromURL: image)
                nameLabel.text = photo.name
            }
        }
    }
}

