import Type_Algebra_Syntax
public import SwiftSyntax
import SwiftSyntaxBuilder

public enum Derivation {
    public static func expansion(of declaration: some DeclGroupSyntax) -> [DeclSyntax] {
        do {
            return try Type.Syntax.Mapping.members(of: declaration, method: "bimap",
                parameters: [.init("MappedFirst", forward: "first"), .init("MappedSecond", forward: "second")])
        } catch { return [DeclSyntax(stringLiteral: "#error(\(String(reflecting: "@Bifunctor " + String(describing: error))))")] }
    }
}
