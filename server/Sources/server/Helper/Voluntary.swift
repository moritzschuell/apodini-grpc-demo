//
//  Created by Nityananda on 04.02.21.
//

/// Workaround to support Swift.Optional. `?` cannot be used because `optional` is an experimental
/// feature. Furhermore, the Swift proto compiler does not support optional.

/// Use `.nothing` with a volunteer to mimic `Optional.none`.
/// Use `.just(v)` with a volutneer to mimic `Optional.some(v)`.

protocol Volunteer {
    static var refuse: Self { get }
}

struct Voluntary<V: Volunteer> {
    /// `true` if the volunteer refused. Otherwise, `false`.
    let isNone: Bool
    let volunteer: V
    
    static var nothing: Self {
        .init(isNone: true, volunteer: V.refuse)
    }
    
    static func just(_ v: V) -> Self {
        .init(isNone: false, volunteer: v)
    }
    
    static func ?? (lhs: Self, rhs: V) -> V {
        lhs.isNone ? rhs : lhs.volunteer
    }
}

extension Voluntary: Encodable where V: Encodable {}
extension Voluntary: Decodable where V: Decodable {}
