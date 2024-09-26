//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Donald Dang on 12/14/24.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = LoadFeedResult //typealias allows us to use the public enum in our Feed Feature
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    /// this func uses the url property in .get so can't use static func; use the weak self instead
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(data, response):
                /// the previous implementation used a data, _ and we never used it so we refactored the testLoadDeliversErrorOnNon200StatusCode to add the makeItemsJSON with an empty list and removed the default Data(). Then we implemented the FeedItemsMapper below to make it cleaner.
                completion(FeedItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    
}


