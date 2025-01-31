//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Donald Dang on 1/31/25.
//

import Foundation


// since this is deterministic and has no side-effects, and has no state, we can make it static. Notice how everything is static so we don't need an instance anymore. Also it has no identity, it just encapsulates a rule. so we can add a private init because it holds no state and nobody can instantiate this type. FeedCachePolicy needs no identity and holds no state. Since it holds no state, we can even make it a struct or enum. 
internal final class FeedCachePolicy {
    private init() {}
    private static let calendar = Calendar(identifier: .gregorian)
    
    private static var maxCacheAgeInDays: Int {
        return 7
    }
    
    internal static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
}
