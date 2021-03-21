//
//  UIColor+UIFont.swift
//  DiscourseClient
//
//  Created by Tim Acosta on 21/3/21.
//  Copyright © 2021 Roberto Garrido. All rights reserved.
//

import UIKit

extension UIFont {
    static let bigTitle = UIFont.systemFont(ofSize: 22, weight: .bold)
    static let title = UIFont.systemFont(ofSize: 17, weight: .semibold)
    static let cellDetail = UIFont.systemFont(ofSize: 14, weight: .regular)
    static let cellDetailBold = UIFont.systemFont(ofSize: 14, weight: .bold)
    
}

extension UIColor {
    static let blackKC = UIColor(named: "BlackKC") ?? UIColor.black
    static let darkGrayKC = UIColor(named: "DarkGrayKC") ?? UIColor.darkGray
    static let grayKC = UIColor(named: "GrayKC") ?? UIColor.gray
    static let orangeKCPumpkin = UIColor(named: "OrangeKCPumpkin") ?? UIColor.orange
    static let orangeKCTangerine = UIColor(named: "OrangeKCTangerine") ?? UIColor.yellow
    static let whiteKCBackground = UIColor(named: "WhiteKCBackground") ?? UIColor.white
    static let whiteKCTabBar = UIColor(named: "WhiteKCTabBar") ?? UIColor.white
}
