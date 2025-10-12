//
//  MainView.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 11.10.2025.
//

import UIKit

final class MainView: UIView {
    lazy var themeView = makeThemeView()
    lazy var christmasCountdownView = makeChristmasCountdownView()
    lazy var whereSantaButton = makeWhereSantaButton()
    
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
private extension MainView {
    func initialize() {
        backgroundColor = UIColor.white
    }
}

// MARK: Make constraints
private extension MainView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            themeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            themeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            themeView.topAnchor.constraint(equalTo: topAnchor),
            themeView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            christmasCountdownView.leadingAnchor.constraint(equalTo: leadingAnchor),
            christmasCountdownView.trailingAnchor.constraint(equalTo: trailingAnchor),
            christmasCountdownView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 21.scale),
            christmasCountdownView.heightAnchor.constraint(equalToConstant: 232.scale)
        ])
        
        NSLayoutConstraint.activate([
            whereSantaButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            whereSantaButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            whereSantaButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30.scale),
            whereSantaButton.heightAnchor.constraint(equalToConstant: 55.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MainView {
    func makeThemeView() -> MainThemeView {
        let view = MainThemeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeChristmasCountdownView() -> ChristmasCountdownView {
        let view = ChristmasCountdownView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeWhereSantaButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 45, green: 12, blue: 78))
            .font(Fonts.NewYork.mediumBold(size: 19.scale))

        let view = UIButton(type: .system)
        view.setAttributedTitle("Main.WhereSanta".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 20.scale
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialLight))
        blur.isUserInteractionEnabled = false
        blur.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blur, at: 0)
        NSLayoutConstraint.activate([
            blur.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blur.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blur.topAnchor.constraint(equalTo: view.topAnchor),
            blur.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let overlay = UIView()
        overlay.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        overlay.isUserInteractionEnabled = false
        overlay.translatesAutoresizingMaskIntoConstraints = false
        blur.contentView.addSubview(overlay)
        NSLayoutConstraint.activate([
            overlay.leadingAnchor.constraint(equalTo: blur.contentView.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: blur.contentView.trailingAnchor),
            overlay.topAnchor.constraint(equalTo: blur.contentView.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: blur.contentView.bottomAnchor)
        ])

        return view
    }
}
