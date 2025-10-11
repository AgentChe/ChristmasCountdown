//
//  ThemesCollectionView.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 11.10.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ThemesCollectionView: UICollectionView {
    private lazy var elements = [ThemesCollectionElement]()
    
    private lazy var didSelectTrigger = PublishRelay<Int>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ThemesCollectionView {
    func setup(elements: [ThemesCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<Int> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension ThemesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .title:
            return dequeueReusableCell(withReuseIdentifier: String(describing: ThemesTitleCell.self), for: indexPath)
        case .theme(let element):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ThemesThemeCell.self), for: indexPath) as! ThemesThemeCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ThemesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch elements[indexPath.row] {
        case .title:
            return CGSize(width: bounds.width, height: 155.scale)
        case .theme:
            return CGSize(width: bounds.width, height: 136.scale)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard case .theme(let theme) = elements[indexPath.row] else { return }
        didSelectTrigger.accept(theme.id)
    }
}

// MARK: Private
private extension ThemesCollectionView {
    func initialize() {
        backgroundColor = UIColor.clear
        showsVerticalScrollIndicator = false
        contentInset = UIEdgeInsets()
        setContentOffset(CGPoint.zero, animated: false)
        
        register(ThemesTitleCell.self, forCellWithReuseIdentifier: String(describing: ThemesTitleCell.self))
        register(ThemesThemeCell.self, forCellWithReuseIdentifier: String(describing: ThemesThemeCell.self))
        
        dataSource = self
        delegate = self
    }
}
