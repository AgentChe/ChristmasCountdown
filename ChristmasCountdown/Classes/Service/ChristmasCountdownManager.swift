//
//  ChristmasCountdownService.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 11.10.2025.
//

//
//  ChristmasCountdownManager.swift
//  ChristmasCountdown
//

import UIKit
import RxSwift
import RxCocoa

final class ChristmasCountdownManager {
    static let shared = ChristmasCountdownManager()

    struct Snapshot: Equatable {
        let days: Int
        let hours: Int
        let minutes: Int
        let seconds: Int
        let isChristmas: Bool
        let target: Date
    }

    let snapshot: Driver<Snapshot>

    private init() {
        let tick = Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
            .map { _ in () }

        let systemTriggers = Observable.merge(
            NotificationCenter.default.rx.notification(UIApplication.significantTimeChangeNotification).map { _ in () },
            NotificationCenter.default.rx.notification(.NSSystemClockDidChange).map { _ in () },
            NotificationCenter.default.rx.notification(.NSSystemTimeZoneDidChange).map { _ in () },
            NotificationCenter.default.rx.notification(.NSCalendarDayChanged).map { _ in () },
            NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification).map { _ in () },
            NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification).map { _ in () }
        )

        let triggers = Observable.merge(tick, systemTriggers)
            .startWith(())

        snapshot = triggers
            .map { Self.makeSnapshot(now: Date(), calendar: Calendar.autoupdatingCurrent) }
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .never())
    }
}

// MARK: - Private
private extension ChristmasCountdownManager {
    static func makeSnapshot(now: Date, calendar: Calendar) -> Snapshot {
        let year = calendar.component(.year, from: now)
        let startThisYear = calendar.date(from: DateComponents(year: year, month: 12, day: 24, hour: 0, minute: 0, second: 0))!
        let endThisYear = calendar.date(byAdding: .day, value: 1, to: startThisYear)!

        if now >= startThisYear && now < endThisYear {
            return Snapshot(days: 0, hours: 0, minutes: 0, seconds: 0, isChristmas: true, target: startThisYear)
        }

        let target = now < startThisYear
        ? startThisYear
        : calendar.date(byAdding: .year, value: 1, to: startThisYear)!

        let comps = calendar.dateComponents([.day, .hour, .minute, .second], from: now, to: target)

        return Snapshot(
            days: max(0, comps.day ?? 0),
            hours: max(0, comps.hour ?? 0),
            minutes: max(0, comps.minute ?? 0),
            seconds: max(0, comps.second ?? 0),
            isChristmas: false,
            target: target
        )
    }
}
