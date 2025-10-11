//
//  MainViewController.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 11.10.2025.
//

import UIKit
import RxSwift

final class MainViewController: UIViewController {
    private lazy var mainView = MainView()
    
    private lazy var viewModel = MainViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: MainViewModel.Input(
            didTapWhereSanta: mainView.whereSantaButton.rx.tap.asSignal()
        ))
        
        output.theme
            .drive(Binder(mainView.themeView) { base, theme in
                base.setup(theme: theme)
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
extension MainViewController {
    static func make() -> NavigationController {
        let vc = MainViewController()
        vc.navigationItem.backButtonTitle = " "
        
        let nc = NavigationController(rootViewController: vc)
        nc.setNavigationBarHidden(true, animated: false)
        
        return nc
    }
}

// MARK: Private
private extension MainViewController {
    func action(_ action: MainViewModel.Action) {
        switch action {
        case .openWhereSanta:
            // TODO
            break 
        }
    }
}
