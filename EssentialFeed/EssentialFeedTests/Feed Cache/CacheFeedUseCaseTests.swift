//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Donald Dang on 1/25/25.
//

import Testing
import EssentialFeed
import Foundation

class LocalFeedLoader {
    private let store: FeedStore
    init(store: FeedStore) {
        self.store = store
    }
    
    func save(_ items: [FeedItem]) {
        store.deleteCachedFeed()
    }
}

class FeedStore {
    var deleteCachedFeedCallCount = 0
    
    func deleteCachedFeed() {
        deleteCachedFeedCallCount += 1
    }
}

struct CacheFeedUseCaseTests {

    @Test func test()  {
        let (sut, store) = makeSUT()
        
        #expect(store.deleteCachedFeedCallCount == 0)
    }
    
    @Test func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem()]
        
        sut.save(items)
        
        #expect(store.deleteCachedFeedCallCount == 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        return (sut, store)
    }
    
    private func uniqueItem() -> FeedItem {
        return FeedItem(id: UUID(), description: "", location: "" , imageURL: anyURL())
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com/")!
    }

}
