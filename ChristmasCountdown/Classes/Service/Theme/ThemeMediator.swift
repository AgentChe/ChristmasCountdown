//
//  ThemeMediator.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 11.10.2025.
//

import RxSwift
import RxCocoa

final class ThemeMediator {
    static let shared = ThemeMediator()
    
    private lazy var didSelectThemeIdTrigger = PublishRelay<Int>()
    
    private init() {}
}

// MARK: Public
extension ThemeMediator {
    func select(themeId: Int) {
        didSelectThemeIdTrigger.accept(themeId)
    }
    
    var didSelectThemeId: Signal<Int> {
        didSelectThemeIdTrigger.asSignal()
    }
}
