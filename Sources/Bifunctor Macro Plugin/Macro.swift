#if BifunctorMacro
    import Bifunctor_Macro_Core
    public import SwiftSyntax
    public import SwiftSyntaxMacros

    public struct Macro: MemberMacro {}

    extension Macro {
        public static func expansion(
            of _: AttributeSyntax,
            providingMembersOf declaration: some DeclGroupSyntax,
            conformingTo _: [TypeSyntax],
            in _: some MacroExpansionContext
        ) throws(MacroExpansionErrorMessage) -> [DeclSyntax] {
            if let enumeration = declaration.as(EnumDeclSyntax.self) {
                return Derivation.expansion(of: enumeration)
            }
            guard let declaration = declaration.as(StructDeclSyntax.self) else {
                throw MacroExpansionErrorMessage(
                    "@Bifunctor applies to a generic struct or enum declaration."
                )
            }
            return Derivation.expansion(of: declaration)
        }
    }
#endif
