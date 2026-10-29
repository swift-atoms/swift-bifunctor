import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct Plugin: CompilerPlugin {
    #if BifunctorMacro
        // swiftlint:disable:next no_any_protocol_existential  // reason: CompilerPlugin requirement
        let providingMacros: [any SwiftSyntaxMacros.Macro.Type] = [Macro.self]
    #else
        // swiftlint:disable:next no_any_protocol_existential  // reason: CompilerPlugin requirement
        let providingMacros: [any SwiftSyntaxMacros.Macro.Type] = []
    #endif
}
