//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Donald Dang on 1/28/25.
//

import Foundation
import EssentialFeed

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func uniqueImageFeed() -> (models: [FeedItem], local: [FeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let local = models.map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.imageURL)}
    return (models, local)
}

func uniqueImage() -> FeedItem {
    return FeedItem(id: UUID(), description: "", location: "" , imageURL: anyURL())
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com/")!
}

extension Date {
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
