//
//  HourlyForecastCell.swift
//  hello_world
//
//  Created by Hannah Valencia on 23/04/26.
//

import Foundation

import UIKit

import UIKit

class HourlyForecastCell: UICollectionViewCell {
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        // Texto
        hourLabel.font = .systemFont(ofSize: 12, weight: .medium)
        hourLabel.textColor = .darkGray
        
        temperatureLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        temperatureLabel.textColor = .black
        
        // Imagen
        weatherImageView.contentMode = .scaleAspectFit
        
        // Card look 
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        contentView.layer.cornerRadius = 12
        
        // sombra ligera
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}
