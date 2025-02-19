//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Donald Dang on 1/26/25.
//

import Foundation



public typealias CachedFeed = (feed: [FeedImage], timestamp: Date)

public protocol FeedStore {
    typealias DeletionResult = Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    typealias InsertionResult = Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    typealias RetrievalResult = Result<CachedFeed?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func retrieve(completion: @escaping RetrievalCompletion)
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func insert(_ feed: [FeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    //func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion) - notice that insert has a source code dependency on FeedItem - in best interest to change that. We can do that by 'importing' types to this modules. What that means is we mirror a local representation of this, but we can add more properties such as a timestamp, which don't exist in the main one for different reasons
}


