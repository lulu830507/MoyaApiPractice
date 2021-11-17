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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = contentView.frame.size.height - 10
        
        contentView.addSubview(dateLabel)
        dateLabel.centerY(inView: contentView, leftAnochor: contentView.leftAnchor, paddingLeft: 10)

        contentView.addSubview(weatherImageView)
        weatherImageView.anchor(top: contentView.topAnchor, left: dateLabel.rightAnchor, paddingLeft: 10, width: imageSize, height: imageSize)
        contentView.addSubview(tempLabel)
        tempLabel.centerY(inView: contentView, leftAnochor: weatherImageView.rightAnchor, paddingLeft: 0)
    }
    
}
