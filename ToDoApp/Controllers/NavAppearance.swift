//
//  NavAppearance.swift
//  ToDoApp
//
//  Created by Sibusiso Mbonani on 2022/08/22.
//

import Foundation
import UIKit

struct NavAppearance {
    
    func homeNavAppearance(_ navItem: UINavigationItem) {
        let navAppear = UINavigationBarAppearance()
        navAppear.configureWithTransparentBackground()
        navAppear.backgroundColor = UIColor(red: 0.88, green: 0.94, blue: 0.92, alpha: 1.0)
        navAppear.titleTextAttributes = [.foregroundColor: UIColor.white]
        navItem.standardAppearance = navAppear
        navItem.scrollEdgeAppearance = navAppear
    }
}
