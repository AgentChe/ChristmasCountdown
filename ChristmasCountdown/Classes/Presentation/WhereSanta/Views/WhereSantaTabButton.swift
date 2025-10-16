//
//  WhereSantaTabButton.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 12.10.2025.
//

import UIKit
import RxCocoa

final class WhereSantaTabButton: UIView {
    enum Tab {
        case santaHouse, santa, home
    }
    
    lazy var marked = false {
        didSet {
            update()
        }
    }
    
    lazy var button = makeButton()
    lazy var iconView = makeIconView()
    
    private lazy var selectedAttrs = TextAttributes()
        .textColor(UIColor.white)
        .font(Fonts.NewYork.mediumBold(size: 17.scale))
    private lazy var normalAttrs = TextAttributes()
        .textColor(UIColor(integralRed: 45, green: 12, blue: 78))
        .font(Fonts.NewYork.mediumBold(size: 17.scale))
    
    private let tab: Tab
    
    init(tab: Tab) {
        self.tab = tab
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WhereSantaTabButton {
    var didTap: Signal<Tab> {
        button.rx.tap
            .compactMap { [weak self] in self?.tab }
            .asSignal(onErrorSignalWith: .never())
    }
}

// MARK: Private
private extension WhereSantaTabButton {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func update() {
        let attrs = marked ? selectedAttrs : normalAttrs
        let title: String = {
            switch tab {
            case .santaHouse:
                return "WhereSanta.Tab.SantaHouse".localized
            case .santa:
                return "WhereSanta.Tab.Santa".localized
            case .home:
                return "WhereSanta.Tab.Home".localized
            }
        }()
        button.setAttributedTitle(title.attributed(with: attrs), for: .normal)
        
        button.backgroundColor = marked ? UIColor(integralRed: 45, green: 12, blue: 78) : UIColor.white
    }
}

// MARK: Make constraints
private extension WhereSantaTabButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.topAnchor.constraint(equalTo: topAnchor, constant: {
                switch tab {
                case .santaHouse:
                    return 41.5.scale
                case .santa:
                    return 39.5.scale
                case .home:
                    return 28.5.scale
                }
            }()),
            button.widthAnchor.constraint(equalToConstant: {
                switch tab {
                case .santaHouse:
                    return 132.scale
                case .santa:
                    return 97.scale
                case .home:
                    return 97.scale
                }
            }()),
            button.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: {
                switch tab {
                case .santaHouse:
                    return 74.scale
                case .santa:
                    return 38.scale
                case .home:
                    return 36.scale
                }
            }()),
            iconView.heightAnchor.constraint(equalToConstant: {
                switch tab {
                case .santaHouse:
                    return 67.scale
                case .santa:
                    return 64.scale
                case .home:
                    return 42.scale
                }
            }()),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: {
                switch tab {
                case .santaHouse:
                    return -16.scale
                case .santa:
                    return -5.scale
                case .home:
                    return -1.scale
                }
            }()),
            iconView.topAnchor.constraint(equalTo: button.topAnchor, constant: {
                switch tab {
                case .santaHouse:
                    return -41.5.scale
                case .santa:
                    return -39.5.scale
                case .home:
                    return -28.5.scale
                }
            }())
        ])
    }
}

// MARK: Lazy initialization
private extension WhereSantaTabButton {
    func makeButton() -> UIButton {
        let view = UIButton()
        view.layer.cornerRadius = 20.scale
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let imageName: String = {
            switch tab {
            case .santaHouse:
                return "WhereSanta.Tab.SantaHouse"
            case .santa:
                return "WhereSanta.Tab.Santa"
            case .home:
                return "WhereSanta.Tab.Home"
            }
        }()
        
        let view = UIImageView()
        view.image = UIImage(named: imageName)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
