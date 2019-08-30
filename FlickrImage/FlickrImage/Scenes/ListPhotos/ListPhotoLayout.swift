//
//  ListPhotoLayout.swift
//  FlickrImage
//
//  Created by Deniz Tav on 29/08/2019.
//  Copyright © 2019 Deniz Tav. All rights reserved.
//

import UIKit

public final class ListPhotoLayout: UICollectionViewFlowLayout {
    //2. Configurable properties
    fileprivate var numberOfColumns: CGFloat = 3
    fileprivate var cellPadding: CGFloat = 10
    fileprivate var photoHeight: CGFloat = 150
    fileprivate var contentHeight: CGFloat = 0
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    /**
     Sets up the layout for the collectionView. 0 distance between each cell,
     and vertical layout
     */
    func setupLayout() {
        minimumInteritemSpacing = cellPadding
        minimumLineSpacing = cellPadding
        scrollDirection = .vertical
    }
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        return collectionView.bounds.width
    }
    
    override public var itemSize: CGSize {
        set {
        }
        get {
            guard numberOfColumns != 1 else {
                return CGSize(width: contentWidth - cellPadding, height: cellPadding + photoHeight)
            }
            let columnWidth = (contentWidth - cellPadding * (numberOfColumns - 1)) / CGFloat(numberOfColumns)
            let columnHeight = cellPadding + photoHeight
            return CGSize(width: columnWidth, height: columnHeight)
        }
    }
}
