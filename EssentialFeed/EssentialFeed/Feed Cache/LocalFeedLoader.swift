//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Donald Dang on 1/26/25.
//

import Foundation
// since this is deterministic and has no side-effects, and has no state, we can make it static. Notice how everything is static so we don't need an instance anymore. Also it has no identity, it just encapsulates a rule. so we can add a private init because it holds no state and nobody can instantiate this type. FeedCachePolicy needs no identity and holds no state.
private final class FeedCachePolicy {
    private init() {}
    private static let calendar = Calendar(identifier: .gregorian)
    
    private static var maxCacheAgeInDays: Int {
        return 7
    }
    
    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
}

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    private let calendar = Calendar(identifier: .gregorian)
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
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

extension LocalFeedLoader {
    public typealias SaveResult = Error?
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
}

extension LocalFeedLoader: FeedLoader {
    public typealias LoadResult = LoadFeedResult
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .found(feed, timestamp) where FeedCachePolicy.validate(timestamp, against: self.currentDate()):
                completion(.success(feed.toModels()))
            case .found:
                completion(.success([]))
            case .empty:
                completion(.success([]))
            }
            
        }
    }
}

extension LocalFeedLoader {
    public func validateCache() {
        store.retrieve { [weak self] result in
            guard let self = self else  { return }
            switch result {
            case .failure:
                self.store.deleteCachedFeed { _ in
                    
                }
            case let .found(feed: _, timestamp: timestamp) where !FeedCachePolicy.validate(timestamp, against: self.currentDate()):
                self.store.deleteCachedFeed { _ in
                    
                }
            case .empty, .found:
                break
            }
        }
    }
}
