//
//  ThemesViewController.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 11.10.2025.
//

import UIKit
import RxSwift

final class ThemesViewController: UIViewController {
    private lazy var mainView = ThemesView()
    
    private lazy var viewModel = ThemesViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: ThemesViewModel.Input(
            didTapBack: mainView.backButton.rx.tap.asSignal(),
            didTapApply: mainView.applyButton.rx.tap.asSignal(),
            didSelect: mainView.collectionView.didSelect
        ))
        
        output.elements
            .drive(Binder(mainView.collectionView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension ThemesViewController {
    static func make() -> ThemesViewController {
        ThemesViewController()
    }
}

// MARK: Private
private extension ThemesViewController {
    func action(_ action: ThemesViewModel.Action) {
        switch action {
        case .close:
            navigationController?.popViewController(animated: true)
        }
    }
}
