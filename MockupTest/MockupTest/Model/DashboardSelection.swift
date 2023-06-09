//
//  DashboardSelection.swift
//  MockupTest
//
//  Created by Kit Foong on 08/06/2023.
//

import Foundation

public class DashboardSelection {
    var title: String = ""
    var isSelected: Bool = false
    
    init(title: String, isSelected: Bool = false) {
        self.title = title
        self.isSelected = isSelected
    }
}
