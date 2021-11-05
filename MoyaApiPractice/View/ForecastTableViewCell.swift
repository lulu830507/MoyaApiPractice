//
//  ForecastTableViewCell.swift
//  MoyaApiPractice
//
//  Created by linssuning on 2021/11/4.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    static let identifier = "ForecastTableViewCell"
    
    // MARK: Properties
    let dateLabel: UILabel = {
       let dateLabel = UILabel()
        dateLabel.backgroundColor = .clear
        dateLabel.tintColor = .black
        dateLabel.text = "11/04 THU 11:00AM"
        dateLabel.font = UIFont(name: "Menlo", size: 17)
        dateLabel.textColor = .black
        return dateLabel
    }()
    
    lazy var weatherImageView: UIImageView = {
        let weatherImage = UIImageView()
        weatherImage.image = UIImage(systemName: "cloud.sun.fill")
        weatherImage.contentMode = .scaleAspectFill
        //weatherImage.tintColor = .white
        return weatherImage
    }()
    
    let tempLabel: UILabel = {
       let tempLabel = UILabel()
        tempLabel.backgroundColor = .clear
        tempLabel.tintColor = .black
        tempLabel.text = "21℃"
        tempLabel.font = UIFont(name: "Menlo", size: 18)
        tempLabel.textColor = .black
        return tempLabel
    }()
    let humidLabel: UILabel = {
       let humidLabel = UILabel()
        humidLabel.backgroundColor = .clear
        humidLabel.tintColor = .black
        humidLabel.text = "56"
        humidLabel.font = UIFont(name: "Menlo", size: 18)
        humidLabel.textColor = .black
        return humidLabel
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(weatherImageView)
        contentView.addSubview(tempLabel)
        //因為太擠了所以不放humidty
        //contentView.addSubview(humidLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = contentView.frame.size.height - 10
        
        dateLabel.frame = CGRect(x: 10, y: 5, width: contentView.frame.size.width / 2 - 10, height: contentView.frame.size.height)
        
        weatherImageView.frame = CGRect(x: 15 + dateLabel.frame.size.width, y: 3, width: imageSize, height: imageSize)
        
        tempLabel.frame = CGRect(x: 15 + weatherImageView.frame.maxX, y: 5, width: contentView.frame.width / 5, height: contentView.frame.size.height)
        
        //humidLabel.frame = CGRect(x: 10 + tempLabel.frame.maxX, y: 5, width: contentView.frame.width / 6, height: contentView.frame.size.height)
    }
    
}
