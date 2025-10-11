//
//  ThemesThemeCell.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 11.10.2025.
//

import UIKit

final class ThemesThemeCell: UICollectionViewCell {
    lazy var imageView = makeImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ThemesThemeCell {
    func setup(element: ThemesThemeElement) {
        imageView.layer.borderWidth = element.selected ? 3.scale : 0
        imageView.layer.borderColor = element.selected ? UIColor(integralRed: 252, green: 201, blue: 80).cgColor : UIColor.clear.cgColor
        
        let imageName = String("Themes.\(element.id)")
        imageView.image = UIImage(named: imageName)
    }
}

// MARK: Private
private extension ThemesThemeCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension ThemesThemeCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 120.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ThemesThemeCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
