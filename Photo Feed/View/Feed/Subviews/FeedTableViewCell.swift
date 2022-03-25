//
//  FeedTableViewCell.swift
//  Photo Feed
//
//  Created by Artem Yakovlev on 24.03.2022.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    @IBOutlet private weak var cellImageView: UIImageView!
    
    public func setImage(_ image: UIImage?) {
        cellImageView.image = image
    }
}
