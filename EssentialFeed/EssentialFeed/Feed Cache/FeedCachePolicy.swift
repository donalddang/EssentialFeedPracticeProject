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