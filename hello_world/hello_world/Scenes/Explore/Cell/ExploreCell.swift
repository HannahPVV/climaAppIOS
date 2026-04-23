//
//  ExploreCell.swift
//  hello_world
//
//  Created by Hannah Valencia on 22/04/26.
//

import UIKit

class ExploreCell: UITableViewCell {

    static let reuseID = "ExploreCell"

    // MARK: - UI Elements

    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 18
        v.layer.shadowColor  = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.08
        v.layer.shadowOffset  = CGSize(width: 0, height: 3)
        v.layer.shadowRadius  = 10
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let cityLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let tempLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        lbl.textColor = UIColor.darkGray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let weatherLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.textColor = UIColor.darkGray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    // Imagen grande a la derecha, igual que la app Android
    private let weatherImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    // Stack vertical para city / temp / weather
    private lazy var textStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [cityLabel, tempLabel, weatherLabel])
        sv.axis = .vertical
        sv.spacing = 2
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor  = .clear
        selectionStyle   = .none
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupLayout() {
        contentView.addSubview(cardView)
        cardView.addSubview(textStack)
        cardView.addSubview(weatherImageView)

        NSLayoutConstraint.activate([
            // Card: márgenes laterales + 8 arriba/abajo
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 90),

            // Stack de texto: izquierda
            textStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            textStack.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            textStack.trailingAnchor.constraint(equalTo: weatherImageView.leadingAnchor, constant: -12),

            // Imagen grande: derecha, cuadrada 64×64
            weatherImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            weatherImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            weatherImageView.widthAnchor.constraint(equalToConstant: 64),
            weatherImageView.heightAnchor.constraint(equalToConstant: 64)
        ])
    }

    // MARK: - Configure

    func configure(with location: LocationModel) {
        cityLabel.text    = location.city
        tempLabel.text    = "\(location.temperature)°C"
        weatherLabel.text = location.weather.rawValue

        // Imagen con SF Symbols en tamaño grande
        let config = UIImage.SymbolConfiguration(pointSize: 52, weight: .regular)
        weatherImageView.image    = UIImage(systemName: location.weather.icon, withConfiguration: config)
        weatherImageView.tintColor = location.weather.iconColor
    }
}
