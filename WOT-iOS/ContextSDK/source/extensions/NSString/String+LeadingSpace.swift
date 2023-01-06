//
//  String+LeadingSpace.swift
//  ContextSDK
//
//  Copyright https://stackoverflow.com/a/52016010
//

extension String {
    func rightJustified(width: Int, truncate: Bool = false, spacer: Character = " ") -> String {
        guard width > count else {
            return truncate ? String(suffix(width)) : self
        }
        return String(repeating: spacer, count: width - count) + self
    }

    func leftJustified(width: Int, truncate: Bool = false, spacer: Character = " ") -> String {
        guard width > count else {
            return truncate ? String(prefix(width)) : self
        }
        return self + String(repeating: spacer, count: width - count)
    }
}
