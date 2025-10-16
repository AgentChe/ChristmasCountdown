//
//  WhereSantaTimeToPresentView.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 15.10.2025.
//

import UIKit

final class WhereSantaTimeToPresentView: UIView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension WhereSantaTimeToPresentView {
    func initialize() {
        backgroundColor = UIColor.white
        layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero
        layer.shadowRadius = 4.scale
        layer.cornerRadius = 20.scale
    }
}

// MARK: Make constraints
private extension WhereSantaTimeToPresentView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 84.scale),
            imageView.heightAnchor.constraint(equalToConstant: 66.scale),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19.scale),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 115.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -19.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 22.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -22.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WhereSantaTimeToPresentView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "WhereSanta.TimeToPresent")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 45, green: 12, blue: 78))
            .font(Fonts.CrimsonText.semiBold(size: 24.scale))
            .lineHeight(27.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.numberOfLines = 2
        view.attributedText = "WhereSanta.TimeToPresents".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
