//
//  MainThemeView.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 11.10.2025.
//

import UIKit
import RxSwift

final class MainThemeView: UIImageView {
    struct Theme {
        let id: Int
        let period: DayPeriodManager.Period
    }
    
    private lazy var disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MainThemeView {
    func setup(theme: Theme) {
        let describingPeriod: String = {
            switch theme.period {
            case .morning:
                return "Morning"
            case .afternoon:
                return "Afternoon"
            case .evening:
                return "Evening"
            case .night:
                return "Night"
            }
        }()
        let name = String("Theme.\(theme.id).\(describingPeriod)")
        image = UIImage(named: name)
    }
}

// MARK: Private
private extension MainThemeView {
    func initialize() {
        backgroundColor = UIColor.clear
        contentMode = .scaleAspectFill
    }
}
