//
//  ChristmasCountdownView.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 11.10.2025.
//

import UIKit
import Lottie

final class ChristmasCountdownView: UIView {
    lazy var christmasInProgressView = makeChristmasInProgressView()
    lazy var titleLabel = makeTitleLabel()
    lazy var counterView = makeCounterView()
    lazy var animationView = makeAnimationView()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(UIColor.white)
        .font(Fonts.NewYork.mediumBold(size: 32.scale))
        .lineHeight(38.scale)
        .textAlignment(.center)
    
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
extension ChristmasCountdownView {
    func setup(christmasCountdown: ChristmasCountdownManager.Snapshot) {
        christmasInProgressView.isHidden = christmasCountdown.isChristmas
        christmasInProgressView.setup(christmasCountdown: christmasCountdown)
        
        let title = christmasCountdown.isChristmas ? "Main.ChristmasCountdown.MerryChristmas".localized : "Main.ChristmasCountdown.ChristmasIn".localized
        titleLabel.attributedText = title.attributed(with: titleAttrs)
        
        counterView.setup(counter: christmasCountdown)
        
        animationView.isHidden = !christmasCountdown.isChristmas
        christmasCountdown.isChristmas ? animationView.play() : animationView.stop()
    }
}

// MARK: Private
private extension ChristmasCountdownView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension ChristmasCountdownView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            christmasInProgressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            christmasInProgressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            christmasInProgressView.topAnchor.constraint(equalTo: topAnchor),
            christmasInProgressView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: counterView.topAnchor, constant: -12.scale)
        ])
        
        NSLayoutConstraint.activate([
            counterView.centerXAnchor.constraint(equalTo: centerXAnchor),
            counterView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            animationView.topAnchor.constraint(equalTo: topAnchor),
            animationView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ChristmasCountdownView {
    func makeChristmasInProgressView() -> ChristmasInProgressView {
        let view = ChristmasInProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCounterView() -> MainCounterView {
        let view = MainCounterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAnimationView() -> LottieAnimationView {
        let view = LottieAnimationView()
        view.animation = LottieAnimation.named("Flex Confetti")
        view.loopMode = .loop
        view.contentMode = .scaleAspectFill
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
