//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by Donald Dang on 2/23/25.
//

import UIKit

public final class FeedImageCell: UITableViewCell {
    public let locationContainer = UIView()
    public let locationLabel = UILabel()
    public let descriptionLabel = UILabel()
}

public extension FeedImageCell {
    var isShowingLocation: Bool {
        return !locationContainer.isHidden
    }
    
    var locationText: String? {
        return locationLabel.text
    }
    var descriptionText: String? {
        return descriptionLabel.text
    }
}
