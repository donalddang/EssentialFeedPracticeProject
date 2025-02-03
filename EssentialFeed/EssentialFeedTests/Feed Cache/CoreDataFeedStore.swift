//
//  CoreDataFeedStore.swift
//  EssentialFeedTests
//
//  Created by Donald Dang on 2/3/25.
//

import Foundation
import EssentialFeed

public final class CoreDataFeedStore: FeedStore {
    public init() {}
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
    
    public func insert(_ feed: [EssentialFeed.FeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    
}
