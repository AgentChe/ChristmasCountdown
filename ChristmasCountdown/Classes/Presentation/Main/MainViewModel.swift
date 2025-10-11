//
//  MainViewModel.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 11.10.2025.
//

import RxSwift
import RxCocoa

final class MainViewModel {
    enum Action {
        case openWhereSanta
    }
    
    private lazy var dayPeriodManager = DayPeriodManager.shared
    private lazy var themeManager = ThemeManager()
}

// MARK: Public
extension MainViewModel {
    struct Input {
        let didTapWhereSanta: Signal<Void>
    }
    
    struct Output {
        let theme: Driver<MainThemeView.Theme>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            theme: makeTheme(themeId: makeThemeId()),
            action: makeAction(didTapWhereSanta: input.didTapWhereSanta)
        )
    }
}

// MARK: Private
private extension MainViewModel {
    func makeTheme(themeId: Driver<Int>) -> Driver<MainThemeView.Theme> {
        Driver
            .combineLatest(themeId, dayPeriodManager.period.asDriver(onErrorDriveWith: .never()))
            .map { themeId, period -> MainThemeView.Theme in
                MainThemeView.Theme(id: themeId, period: period)
            }
    }
    
    func makeThemeId() -> Driver<Int> {
        let initial = themeManager
            .fetchSelectedThemeId()
            .asDriver(onErrorDriveWith: .never())
        
        let updated = ThemeMediator.shared
            .didSelectThemeId
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(initial, updated)
    }
    
    func makeAction(didTapWhereSanta: Signal<Void>) -> Driver<Action> {
        didTapWhereSanta
            .map { Action.openWhereSanta }
            .asDriver(onErrorDriveWith: .never())
    }
}
