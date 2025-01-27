//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Donald Dang on 1/26/25.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    public typealias SaveResult = Error?
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ feed: [FeedItem], completion: @escaping (Error?) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                completion(error)
            } else {
                self.cache(feed, with: completion)
            }
        }
    }
    private func cache(_ feed: [FeedItem], with completion: @escaping (Error?) -> Void) {
        store.insert(feed.toLocal(), timestamp: self.currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
    
    public func load() {
        store.retrieve()
    }
}

private extension Array where Element == FeedItem {
    func toLocal() -> [FeedImage] {
        return map { FeedImage(id: $0.id, description: $0.description, location: $0.description, url: $0.imageURL)}
    }
}
