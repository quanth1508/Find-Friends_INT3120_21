//
//  FFHelper.swift
//  FindFriends
//
//  Created by Quan Tran on 08/11/2022.
//

import Foundation



// MARK: - Foundation Helper
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var uniqueSet = Set<Element>()
        var    result = Array<Element>()
        
        for (_, el) in self.enumerated() {
            if !uniqueSet.contains(el) {
                uniqueSet.insert(el)
                result.append(el)
            }
        }
        
        return result
    }
}
