//
//  WeatherLabel.swift
//  MoyaApiPractice
//
//  Created by linssuning on 2021/11/11.
//

import UIKit

class WeatherLabel: UILabel {
    
    init(text: String, font: Int) {
        super.init(frame: CGRect())
        
        backgroundColor = .clear
        tintColor = .white
        textColor = .white
        self.font = UIFont(name: "Menlo", size: CGFloat(font))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
