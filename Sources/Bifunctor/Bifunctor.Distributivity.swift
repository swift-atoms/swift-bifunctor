public import Either
public import Pair

extension Bifunctor {

    public enum Distributivity: Sendable {}
}

extension Bifunctor.Distributivity {

    @inlinable
    @_lifetime(copy pair)
    public static func distribute<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        C: ~Copyable & ~Escapable
    >(
        _ pair: consuming Pair<A, Either<B, C>>
    ) -> Either<Pair<A, B>, Pair<A, C>> {
        switch consume pair.second {
        case .left(let b):
            return .left(Pair<A, B>(pair.first, b))

        case .right(let c):
            return .right(Pair<A, C>(pair.first, c))
        }
    }

    @inlinable
    @_lifetime(copy pair)
    public static func distribute<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        C: ~Copyable & ~Escapable
    >(
        _ pair: consuming Pair<Either<A, B>, C>
    ) -> Either<Pair<A, C>, Pair<B, C>> {
        switch consume pair.first {
        case .left(let a):
            return .left(Pair<A, C>(a, pair.second))

        case .right(let b):
            return .right(Pair<B, C>(b, pair.second))
        }
    }
}

extension Bifunctor.Distributivity {

    @inlinable
    @_lifetime(copy either)
    public static func factor<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        C: ~Copyable & ~Escapable
    >(
        _ either: consuming Either<Pair<A, B>, Pair<A, C>>
    ) -> Pair<A, Either<B, C>> {

        switch consume either {
        case .left(let pairAB):
            return Self._packLeftSecond(pairAB)

        case .right(let pairAC):
            return Self._packRightSecond(pairAC)
        }
    }

    @inlinable
    @_lifetime(copy either)
    public static func factor<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        C: ~Copyable & ~Escapable
    >(
        _ either: consuming Either<Pair<A, C>, Pair<B, C>>
    ) -> Pair<Either<A, B>, C> {
        switch consume either {
        case .left(let pairAC):
            return Self._packLeftFirst(pairAC)

        case .right(let pairBC):
            return Self._packRightFirst(pairBC)
        }
    }
}

extension Bifunctor.Distributivity {

    @inlinable
    @_lifetime(copy pair)
    package static func _packLeftSecond<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        C: ~Copyable & ~Escapable
    >(
        _ pair: consuming Pair<A, B>
    ) -> Pair<A, Either<B, C>> {
        Pair<A, Either<B, C>>(pair.first, .left(pair.second))
    }

    @inlinable
    @_lifetime(copy pair)
    package static func _packRightSecond<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        C: ~Copyable & ~Escapable
    >(
        _ pair: consuming Pair<A, C>
    ) -> Pair<A, Either<B, C>> {
        Pair<A, Either<B, C>>(pair.first, .right(pair.second))
    }

    @inlinable
    @_lifetime(copy pair)
    package static func _packLeftFirst<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        C: ~Copyable & ~Escapable
    >(
        _ pair: consuming Pair<A, C>
    ) -> Pair<Either<A, B>, C> {
        Pair<Either<A, B>, C>(.left(pair.first), pair.second)
    }

    @inlinable
    @_lifetime(copy pair)
    package static func _packRightFirst<
        A: ~Copyable & ~Escapable,
        B: ~Copyable & ~Escapable,
        C: ~Copyable & ~Escapable
    >(
        _ pair: consuming Pair<B, C>
    ) -> Pair<Either<A, B>, C> {
        Pair<Either<A, B>, C>(.right(pair.first), pair.second)
    }
}
