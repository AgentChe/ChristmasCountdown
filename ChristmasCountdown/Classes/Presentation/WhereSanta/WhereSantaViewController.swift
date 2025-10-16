//
//  WhereSantaViewController.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 12.10.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class WhereSantaViewController: UIViewController {
    private lazy var mainView = WhereSantaView()
    
    private lazy var viewModel = WhereSantaViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let didTapTabButton = Signal
            .merge(
                mainView.santaHouseButton.didTap,
                mainView.santaButton.didTap,
                mainView.homeButton.didTap
            )
        
        let output = viewModel.configure(input: WhereSantaViewModel.Input(
            didTapBack: mainView.backButton.rx.tap.asSignal(),
            didTapThemes: mainView.themesButton.rx.tap.asSignal(),
            didTapTabButton: didTapTabButton
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.selectedTab
            .drive(Binder(mainView) { base, tab in
                base.setup(tab: tab)
            })
            .disposed(by: disposeBag)
        
        output.isChristmas
            .drive(Binder(mainView) { base, isChristmas in
                base.setup(isChristmas: isChristmas)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension WhereSantaViewController {
    static func make() -> WhereSantaViewController {
        let vc = WhereSantaViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension WhereSantaViewController {
    func action(_ action: WhereSantaViewModel.Action) {
        switch action {
        case .close:
            navigationController?.popViewController(animated: true)
        case .openThemes:
            let vc = ThemesViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
