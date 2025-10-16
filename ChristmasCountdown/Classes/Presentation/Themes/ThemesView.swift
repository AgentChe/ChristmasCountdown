//
//  ThemesView.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 11.10.2025.
//

import UIKit

final class ThemesView: UIView {
    lazy var backButton = makeBackButton()
    lazy var collectionView = makeCollectionView()
    lazy var applyButton = makeApplyButton()
    
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
private extension ThemesView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 20, green: 5, blue: 35)
    }
}

// MARK: Make constraints
private extension ThemesView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 40.scale),
            backButton.heightAnchor.constraint(equalToConstant: 40.scale),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -1.scale)
        ])
        
        NSLayoutConstraint.activate([
            applyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            applyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            applyButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30.scale),
            applyButton.heightAnchor.constraint(equalToConstant: 55.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ThemesView {
    func makeBackButton() -> UIButton {
        var cfg = UIButton.Configuration.plain()
        cfg.image = UIImage(named: "Back")?.withRenderingMode(.alwaysOriginal)
        cfg.contentInsets = .zero
        cfg.background = .clear()
        cfg.background.visualEffect = UIBlurEffect(style: .systemThinMaterialLight)
        cfg.background.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        cfg.background.cornerRadius = 20.scale
        
        let view = UIButton(type: .system)
        view.configuration = cfg
        view.layer.cornerRadius = 20.scale
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> ThemesCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let view = ThemesCollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeApplyButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 45, green: 12, blue: 78))
            .font(Fonts.NewYork.mediumBold(size: 19.scale))

        let view = UIButton(type: .system)
        view.setAttributedTitle("Themes.Apply".localized.attributed(with: attrs), for: .normal)
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
