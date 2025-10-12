//
//  MainCounterValueView.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 11.10.2025.
//

import UIKit

final class MainCounterValueView: UIView {
    lazy var valueLabel = makeLabel()
    lazy var titleLabel = makeTitleLabel()
    
    private let title: String
    
    private lazy var valueAttrs = TextAttributes()
        .textColor(UIColor.white)
        .font(Fonts.CrimsonText.semiBold(size: 52.scale))
        .lineHeight(68.scale)
        .textAlignment(.center)
    
    init(title: String) {
        self.title = title
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MainCounterValueView {
    func setup(value: String) {
        valueLabel.attributedText = value.attributed(with: valueAttrs)
    }
}

// MARK: Private
private extension MainCounterValueView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension MainCounterValueView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension MainCounterValueView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.NewYork.mediumBold(size: 15.scale))
            .lineHeight(18.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
