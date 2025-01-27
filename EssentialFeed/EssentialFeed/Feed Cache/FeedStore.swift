//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Donald Dang on 1/26/25.
//

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func retrieve()
    func insert(_ feed: [FeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    //func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion) - notice that insert has a source code dependency on FeedItem - in best interest to change that. We can do that by 'importing' types to this modules. What that means is we mirror a local representation of this, but we can add more properties such as a timestamp, which don't exist in the main one for different reasons
}


