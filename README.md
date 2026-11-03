# swift-bifunctor

Use this package when a value has two independent type parameters you want to map at once, or when you need to move between a pair holding a choice and a choice of pairs. Start from the `@Bifunctor` macro (in `Bifunctor Macro`, enabled by the `BifunctorMacro` trait) to derive `bimap` on a generic struct or enum, and from `Bifunctor.Distributivity` to convert between `Pair` of `Either` and `Either` of `Pair`. For a type with one mapped parameter use swift-functor instead; for one contravariant and one covariant parameter use swift-profunctor.

## Laws

- A derived `bimap` preserves identity: mapping both parameters with the identity function returns an equal value.
- A derived `bimap` composes per side: mapping the first parameter and then the second equals mapping both in one call.
- A derived `bimap` reaches the type parameters wherever they occur inside stored properties and associated values, including through nested containers such as arrays of optionals; payload-free enum cases are carried over unchanged.
- `Bifunctor.Distributivity.distribute` and `Bifunctor.Distributivity.factor` are mutually inverse in both directions, for the `Either` in the second position and in the first.
- Both directions keep the side: a `.left` choice becomes `.left` and a `.right` choice becomes `.right`, and the shared component is moved unchanged.
- When `@Bifunctor` cannot derive `bimap` for a struct or enum, the expansion is a compile-time `#error` whose message starts with `@Bifunctor`, not a thrown macro diagnostic.
