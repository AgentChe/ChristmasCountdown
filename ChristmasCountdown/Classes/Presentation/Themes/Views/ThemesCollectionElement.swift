//
//  ThemesCollectionElement.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 11.10.2025.
//

enum ThemesCollectionElement {
    case title
    case theme(ThemesThemeElement)
}

final class ThemesThemeElement {
    let id: Int
    var selected: Bool
    
    init(id: Int, selected: Bool) {
        self.id = id
        self.selected = selected
    }
}
