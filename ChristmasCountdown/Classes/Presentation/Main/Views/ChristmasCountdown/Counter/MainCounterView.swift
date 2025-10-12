//
//  MainCounterView.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 11.10.2025.
//

import UIKit

final class MainCounterView: UIView {
    lazy var daysView = makeValueView(title: "Main.Counter.Days".localized)
    lazy var divLabel = makeDivLabel()
    lazy var hoursView = makeValueView(title: "Main.Counter.Hours".localized)
    lazy var minView = makeValueView(title: "Main.Counter.Min".localized)
    lazy var secView = makeValueView(title: "Main.Counter.Sec".localized)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MainCounterView {
    func setup(counter: ChristmasCountdownManager.Snapshot) {
        let fmt: (Int) -> String = { String(format: "%02d", max(0, $0)) }
                
        daysView.setup(value: fmt(counter.days))
        hoursView.setup(value: fmt(counter.hours))
        minView.setup(value: fmt(counter.minutes))
        secView.setup(value: fmt(counter.seconds))
    }
}

// MARK: Private
private extension MainCounterView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension MainCounterView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            daysView.leadingAnchor.constraint(equalTo: leadingAnchor),
            daysView.topAnchor.constraint(equalTo: topAnchor),
            daysView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            divLabel.leadingAnchor.constraint(equalTo: daysView.trailingAnchor, constant: 6.scale),
            divLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            hoursView.leadingAnchor.constraint(equalTo: daysView.trailingAnchor, constant: 22.scale),
            hoursView.topAnchor.constraint(equalTo: topAnchor),
            hoursView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            minView.leadingAnchor.constraint(equalTo: hoursView.trailingAnchor, constant: 16.scale),
            minView.topAnchor.constraint(equalTo: topAnchor),
            minView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            secView.leadingAnchor.constraint(equalTo: minView.trailingAnchor, constant: 6.scale),
            secView.trailingAnchor.constraint(equalTo: trailingAnchor),
            secView.topAnchor.constraint(equalTo: topAnchor),
            secView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension MainCounterView {
    func makeValueView(title: String) -> MainCounterValueView {
        let view = MainCounterValueView(title: title)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDivLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.CrimsonText.semiBold(size: 48.scale))
            .lineHeight(64.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = ":".attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
