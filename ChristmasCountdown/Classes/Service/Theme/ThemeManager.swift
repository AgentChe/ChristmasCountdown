//
//  ThemeManager.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 11.10.2025.
//

import RxSwift

final class ThemeManager {
    enum Constants {
        static let selectedThemeIdKey = "selected_theme_id_key"
    }
}

// MARK: Public
extension ThemeManager {
    func select(themeId: Int) -> Single<Void> {
        Single<Void>.create { single in
            UserDefaults.standard.set(themeId, forKey: Constants.selectedThemeIdKey)
            
            single(.success(Void()))
            
            ThemeMediator.shared.select(themeId: themeId)
            
            return Disposables.create()
        }
    }
    
    func fetchSelectedThemeId() -> Single<Int> {
        Single<Int>.create { single in
            let themeId = UserDefaults.standard.value(forKey: Constants.selectedThemeIdKey) as? Int ?? 1
            
            single(.success(themeId))
            
            return Disposables.create()
        }
    }
}
