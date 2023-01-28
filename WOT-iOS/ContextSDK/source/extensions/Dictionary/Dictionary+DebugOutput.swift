//
//  Dictionary+DebugOutput.swift
//  ContextSDK
//
//  Created by Paul on 28.01.23.
//

extension Dictionary where Key == AnyHashable, Value == Any {

    public func debugOutput() -> String {
        guard let jsonValue = JSONValue(any: self) else {
            return "Invalid json"
        }
        do {
            return try jsonValue.encode()?.unescaped ?? "Encoding error: <unknown>"
        } catch {
            return "Encoding error: \(error)"
        }
    }
}
