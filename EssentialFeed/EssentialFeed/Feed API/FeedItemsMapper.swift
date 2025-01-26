//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Donald Dang on 1/18/25.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL

}

internal final class FeedItemsMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }

    
    /// static func means we don't have to explicitly call self, or create an instance
    /// alternatively we can use the weak self stuff, but if we guard self = self then the blocks below won't be executed
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == 200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return root.items
    }
}
