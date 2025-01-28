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
    public typealias LoadResult = LoadFeedResult
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
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .found(feed, timestamp) where self.validate(timestamp):
                completion(.success(feed.toModels()))
            case .found:
                completion(.success([]))
            case .empty:
                completion(.success([]))
            }
            
        }
    }
    
    public func validateCache() {
        store.retrieve { [weak self] result in
            guard let self = self else  { return }
            switch result {
            case .failure:
                self.store.deleteCachedFeed { _ in
                    
                }
            case let .found(feed: _, timestamp: timestamp) where !self.validate(timestamp):
                self.store.deleteCachedFeed { _ in
                    
                }
            case .empty, .found:
                break
            }
        }
    }
    
    private func validate(_ timestamp: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        guard let maxCacheAge = calendar.date(byAdding: .day, value: 7, to: timestamp) else {
            return false
        }
        return currentDate() < maxCacheAge
    }
}

private extension Array where Element == FeedItem {
    func toLocal() -> [FeedImage] {
        return map { FeedImage(id: $0.id, description: $0.description, location: $0.description, url: $0.imageURL)}
    }
}

private extension Array where Element == FeedImage {
    func toModels() -> [FeedItem] {
        return map { FeedItem(id: $0.id, description: $0.description, location: $0.location, imageURL: $0.url)}
    }
}
