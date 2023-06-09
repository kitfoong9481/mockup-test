//
//  Optional+Extension.swift
//  MockupTest
//
//  Created by Kit Foong on 07/06/2023.
//

import Foundation

extension Optional where Wrapped == String {
    public func or(_ val: String) -> String {
        guard self != nil else { return String.empty }
        return val
    }
    
    public var orEmpty: String {
        guard let _string = self else { return String.empty }
        return _string
    }
}

public extension String {    
    static var empty: String {
        return ""
    }
    
    func isValidURL() -> Bool {
        let escapedString = self.removingPercentEncoding
        
        let head = "((http|https)://)?([(w|W)]{3}+\\.)?"
        let tail = "\\.+[A-Za-z]{2,3}+(\\.)?+(/(.)*)?"
        let urlRegEx = head + "+(.)+" + tail
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        return predicate.evaluate(with: escapedString)
    }
}

