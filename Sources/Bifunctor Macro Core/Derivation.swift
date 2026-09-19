import Type_Algebra_Syntax
public import SwiftSyntax
import SwiftSyntaxBuilder

public enum Derivation {
    public static func expansion(of structure: StructDeclSyntax) -> [DeclSyntax] {
        do {
            let shape = try GenericProduct(structure, arity: 2)
            let parameters = shape.parameters
            let escaping = shape.fields.contains { $0.containsArrow } ? "@escaping " : ""
            let fields = shape.properties.fields
            let forward: [String: String] = [parameters[0]: "first", parameters[1]: "second"]
            let backward: [String: String] = [:]
            let arguments = try fields.enumerated().map { index, field in
                field.name + ": " + (try MappingExpression.apply(shape.fields[index], to: "self.\(field.name)", forward: forward, backward: backward))
            }.joined(separator: ", ")
            return [DeclSyntax(stringLiteral: """
                \(shape.access)func bimap<MappedFirst, MappedSecond>(_ first: \(escaping)(\(parameters[0])) -> MappedFirst, _ second: \(escaping)(\(parameters[1])) -> MappedSecond) -> \(structure.name.text)<MappedFirst, MappedSecond> {
                    \(structure.name.text)<MappedFirst, MappedSecond>(\(arguments))
                }
                """)]
        } catch { return [DeclSyntax(stringLiteral: "#error(\(String(reflecting: "@Bifunctor " + String(describing: error))))")] }
    }
}

extension Derivation {
    public static func expansion(of enumeration: EnumDeclSyntax) -> [DeclSyntax] {
        do {
            guard let generics = enumeration.genericParameterClause, generics.parameters.count == 2,
                generics.parameters.allSatisfy({ $0.inheritedType == nil }), enumeration.genericWhereClause == nil else {
                throw AlgebraDiagnostic("requires 2 unconstrained generic parameter(s)")
            }
            let parameters = generics.parameters.map(\.name.text)
            let cases = RecursiveShape.elements(of: enumeration)
            let escaping = cases.flatMap { RecursiveShape.parameters(of: $0) }.contains { TypeExpression($0.type, parameters: Set(parameters)).containsArrow } ? "@escaping " : ""
            let branches = try cases.map { item -> String in
                let payloads = RecursiveShape.parameters(of: item)
                if payloads.isEmpty { return "case .\(item.name.text): return .\(item.name.text)" }
                let arguments = try payloads.enumerated().map { index, payload in
                    let label = RecursiveShape.label(of: payload).map { "\($0): " } ?? ""
                    return label + (try MappingExpression.apply(TypeExpression(payload.type, parameters: Set(parameters)),
                        to: "value\(index)", forward: [parameters[0]: "first", parameters[1]: "second"]))
                }
                return "case let .\(item.name.text)(\(payloads.indices.map { "value\($0)" }.joined(separator: ", "))): return .\(item.name.text)(\(arguments.joined(separator: ", ")))"
            }.joined(separator: "\n")
            return [DeclSyntax(stringLiteral: """
                \(RecursiveShape.access(of: enumeration))func bimap<MappedFirst, MappedSecond>(_ first: \(escaping)(\(parameters[0])) -> MappedFirst, _ second: \(escaping)(\(parameters[1])) -> MappedSecond) -> \(enumeration.name.text)<MappedFirst, MappedSecond> {
                    switch self { \(branches) }
                }
                """)]
        } catch { return [DeclSyntax(stringLiteral: "#error(\(String(reflecting: "@Bifunctor " + String(describing: error))))")] }
    }
}
