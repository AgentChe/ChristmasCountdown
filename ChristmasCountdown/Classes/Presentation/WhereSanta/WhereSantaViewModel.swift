//
//  WhereSantaViewModel.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 12.10.2025.
//

import RxSwift
import RxCocoa

final class WhereSantaViewModel {
    enum Action {
        case close
        case openThemes
        case openPaygate
    }
    
    enum Tab: Equatable {
        case santaHouse
        case santa
        case home(ChristmasCountdownManager.Snapshot)
    }
    
    private lazy var christmasCountdownManager = ChristmasCountdownManager.shared
}

// MARK: Public
extension WhereSantaViewModel {
    struct Input {
        let didTapBack: Signal<Void>
        let didTapThemes: Signal<Void>
        let didTapTabButton: Signal<WhereSantaTabButton.Tab>
    }
    
    struct Output {
        let action: Driver<Action>
        let selectedTab: Driver<Tab>
        let isChristmas: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let christmasCountdown = christmasCountdownManager.snapshot
        
        return Output(
            action: makeAction(
                didTapBack: input.didTapBack,
                didTapThemes: input.didTapThemes,
                didTapTabButton: input.didTapTabButton
            ),
            selectedTab: makeSelectedTab(
                didTapTabButton: input.didTapTabButton,
                christmasCountdown: christmasCountdown
            ),
            isChristmas: christmasCountdown.map { $0.isChristmas }
        )
    }
}

// MARK: Private
private extension WhereSantaViewModel {
    func makeAction(
        didTapBack: Signal<Void>,
        didTapThemes: Signal<Void>,
        didTapTabButton: Signal<WhereSantaTabButton.Tab>
    ) -> Driver<Action> {
        let close = didTapBack
            .map { Action.close }
            .asDriver(onErrorDriveWith: .never())
        
        let openThemes = didTapThemes
            .map { Action.openThemes }
            .asDriver(onErrorDriveWith: .never())
        
        let openPaygate = didTapTabButton
            .filter { tab -> Bool in
                switch tab {
                case .home:
                    return !SessionManager().hasActiveSubscriptions()
                default:
                    return false
                }
            }
            .map { _ in Action.openPaygate }  
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(close, openThemes, openPaygate)
    }
    
    func makeSelectedTab(
        didTapTabButton: Signal<WhereSantaTabButton.Tab>,
        christmasCountdown: Driver<ChristmasCountdownManager.Snapshot>
    ) -> Driver<Tab> {
        didTapTabButton
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(christmasCountdown) { ($0, $1) }
            .compactMap { tab, christmasCountdown -> Tab? in
                switch tab {
                case .santaHouse:
                    return .santaHouse
                case .santa:
                    return .santa
                case .home:
                    return SessionManager().hasActiveSubscriptions() ? .home(christmasCountdown) : nil
                }
            }
            .startWith(.santaHouse)
    }
}
