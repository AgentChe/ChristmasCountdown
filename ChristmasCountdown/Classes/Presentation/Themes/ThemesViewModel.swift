//
//  ThemesViewModel.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 11.10.2025.
//

import RxSwift
import RxCocoa

final class ThemesViewModel {
    enum Action {
        case close
        case openPaygate
    }
    
    private lazy var themeManager = ThemeManager()
}

// MARK: Public
extension ThemesViewModel {
    struct Input {
        let didTapBack: Signal<Void>
        let didTapApply: Signal<Void>
        let didSelect: Signal<Int>
    }
    
    struct Output {
        let elements: Driver<[ThemesCollectionElement]>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        let selectedId = makeSelectedId(didSelect: input.didSelect)
        
        return Output(
            elements: makeElements(selectedId: selectedId),
            action: makeAction(
                selectedId: selectedId,
                didTapBack: input.didTapBack,
                didTapApply: input.didTapApply
            )
        )
    }
}

// MARK: Private
private extension ThemesViewModel {
    func makeElements(selectedId: Driver<Int>) -> Driver<[ThemesCollectionElement]> {
        selectedId
            .map { selectedId -> [ThemesCollectionElement] in
                [
                    .title,
                    .theme(ThemesThemeElement(id: 1, selected: selectedId == 1)),
                    .theme(ThemesThemeElement(id: 2, selected: selectedId == 2)),
                    .theme(ThemesThemeElement(id: 3, selected: selectedId == 3))
                ]
            }
    }
    
    func makeSelectedId(didSelect: Signal<Int>) -> Driver<Int> {
        Driver
            .merge(
                themeManager
                    .fetchSelectedThemeId()
                    .asDriver(onErrorDriveWith: .never()),
                didSelect.asDriver(onErrorDriveWith: .never())
            )
    }
    
    func makeAction(
        selectedId: Driver<Int>,
        didTapBack: Signal<Void>,
        didTapApply: Signal<Void>
    ) -> Driver<Action> {
        let close = didTapBack
            .map { Action.close }
            .asDriver(onErrorDriveWith: .never())
        
        let apply = didTapApply
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(selectedId)
            .flatMapLatest { [weak self] selectedId -> Driver<Action> in
                guard let self else { return .never() }
                
                if !SessionManager().hasActiveSubscriptions() {
                    return .just(.openPaygate)
                }
                
                return themeManager
                    .select(themeId: selectedId)
                    .map { Action.close }
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(close, apply)
    }
}
