//
//  WhereSantaView.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 12.10.2025.
//

import UIKit
import Lottie

final class WhereSantaView: UIView {
    lazy var mapView = makeMapView()
    lazy var backButton = makeButton(imageName: "Back")
    lazy var themesButton = makeButton(imageName: "WhereSanta.Themes")
    lazy var santaHouseButton = makeTabButton(tab: .santaHouse)
    lazy var santaButton = makeTabButton(tab: .santa)
    lazy var homeButton = makeTabButton(tab: .home)
    
    private var timeToPresents: WhereSantaTimeToPresentView?
    private var animationView: LottieAnimationView?
    
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
extension WhereSantaView {
    func setup(tab: WhereSantaViewModel.Tab) {
        santaHouseButton.marked = tab == .santaHouse
        santaButton.marked = tab == .santa
        homeButton.marked = {
            guard case .home = tab else { return false }
            return true
        }()
        
        switch tab {
        case .santaHouse:
            mapView.showSantaHouse()
        case .santa:
            mapView.showSanta()
        case .home(let countdown):
            mapView.showHome(countdown: countdown)
        }
    }
    
    func setup(isChristmas: Bool) {
        switch isChristmas {
        case true:
            let timeToPresents = WhereSantaTimeToPresentView()
            timeToPresents.translatesAutoresizingMaskIntoConstraints = false
            addSubview(timeToPresents)
            
            self.timeToPresents = timeToPresents
            
            NSLayoutConstraint.activate([
                timeToPresents.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18.scale),
                timeToPresents.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18.scale),
                timeToPresents.bottomAnchor.constraint(equalTo: santaButton.topAnchor, constant: -45.scale)
            ])
            
            let animationView = LottieAnimationView()
            animationView.animation = LottieAnimation.named("Flex Confetti")
            animationView.loopMode = .loop
            animationView.contentMode = .scaleAspectFill
            animationView.backgroundColor = UIColor.clear
            animationView.isUserInteractionEnabled = false
            animationView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(animationView)
            
            self.animationView = animationView
            
            NSLayoutConstraint.activate([
                animationView.leadingAnchor.constraint(equalTo: leadingAnchor),
                animationView.trailingAnchor.constraint(equalTo: trailingAnchor),
                animationView.bottomAnchor.constraint(equalTo: timeToPresents.topAnchor),
                animationView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
            ])
            
            animationView.play()
        case false:
            timeToPresents?.removeFromSuperview()
            timeToPresents = nil
            
            animationView?.removeFromSuperview()
            animationView = nil
        }
    }
}

// MARK: Private
private extension WhereSantaView {
    func initialize() {
        backgroundColor = UIColor.white
    }
}

// MARK: Make constraints
private extension WhereSantaView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 40.scale),
            backButton.heightAnchor.constraint(equalToConstant: 40.scale),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            themesButton.widthAnchor.constraint(equalToConstant: 40.scale),
            themesButton.heightAnchor.constraint(equalToConstant: 40.scale),
            themesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11.scale),
            themesButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            santaHouseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.scale),
            santaHouseButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            santaButton.leadingAnchor.constraint(equalTo: santaHouseButton.trailingAnchor, constant: 16.scale),
            santaButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            homeButton.leadingAnchor.constraint(equalTo: santaButton.trailingAnchor, constant: 16.scale),
            homeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WhereSantaView {
    func makeMapView() -> WhereSantaMapView {
        let view = WhereSantaMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton(imageName: String) -> UIButton {
        var cfg = UIButton.Configuration.plain()
        cfg.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
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
    
    func makeTabButton(tab: WhereSantaTabButton.Tab) -> WhereSantaTabButton {
        let view = WhereSantaTabButton(tab: tab)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
