//
//  DayPeriodManager.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 11.10.2025.
//

//
//  DayPeriodManager.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 11.10.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class DayPeriodManager {
    static let shared = DayPeriodManager()

    enum Period: Equatable {
        case morning, afternoon, evening, night
    }

    private let periodRelay: BehaviorRelay<Period>
    
    private var boundaryTimer: DispatchSourceTimer?

    private var calendar: Calendar {
        Calendar.autoupdatingCurrent
    }
    
    private let disposeBag = DisposeBag()

    private init() {
        let initial = Self.periodFor(date: Date(), calendar: Calendar.autoupdatingCurrent)
        self.periodRelay = BehaviorRelay(value: initial)
        
        scheduleBoundaryTimer(from: Date())
        
        let nc = NotificationCenter.default.rx
        Observable.merge(
            nc.notification(UIApplication.significantTimeChangeNotification).map { _ in () },
            nc.notification(NSNotification.Name.NSSystemClockDidChange).map { _ in () },
            nc.notification(NSNotification.Name.NSSystemTimeZoneDidChange).map { _ in () },
            nc.notification(NSNotification.Name.NSCalendarDayChanged).map { _ in () },
            nc.notification(UIApplication.willEnterForegroundNotification).map { _ in () }
        )
        .subscribe(onNext: { [weak self] in
            self?.handleSystemTimeEvent()
        })
        .disposed(by: disposeBag)
    }
}

// MARK: Public
extension DayPeriodManager {
    var period: Signal<Period> {
        periodRelay
            .distinctUntilChanged()
            .asSignal(onErrorSignalWith: .never())
    }
}

// MARK: Private
private extension DayPeriodManager {
    func handleSystemTimeEvent() {
        let now = Date()
        
        let newPeriod = Self.periodFor(date: now, calendar: calendar)
        
        if newPeriod != periodRelay.value {
            periodRelay.accept(newPeriod)
        }
        
        scheduleBoundaryTimer(from: now)
    }

    func scheduleBoundaryTimer(from date: Date) {
        boundaryTimer?.setEventHandler {}
        boundaryTimer?.cancel()
        boundaryTimer = nil

        let next = Self.nextBoundary(after: date, calendar: calendar)

        let seconds = next.timeIntervalSince1970
        let sec = Int(seconds.rounded(.down))
        let nsec = Int((seconds - Double(sec)) * 1_000_000_000)
        let ts = timespec(tv_sec: sec, tv_nsec: nsec)
        let wall = DispatchWallTime(timespec: ts)

        let timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(wallDeadline: wall)
        timer.setEventHandler { [weak self] in
            guard let self else { return }
            
            let now = Date()
            
            let p = Self.periodFor(date: now, calendar: calendar)
            
            if p != self.periodRelay.value {
                periodRelay.accept(p)
            }
            
            scheduleBoundaryTimer(from: now)
        }
        boundaryTimer = timer
        timer.resume()
    }

    static func periodFor(date: Date, calendar: Calendar) -> DayPeriodManager.Period {
        switch calendar.component(.hour, from: date) {
        case 6...11:
            return .morning
        case 12...17:
            return .afternoon
        case 18...21:
            return .evening
        default:
            return .night
        }
    }

    static func nextBoundary(after date: Date, calendar: Calendar) -> Date {
        let dayStart = calendar.startOfDay(for: date)
        
        var candidates = [6, 12, 18, 22].compactMap { hour -> Date? in
            calendar.date(byAdding: .hour, value: hour, to: dayStart)
        }
        
        if let nextMorning = calendar.date(byAdding: DateComponents(day: 1, hour: 6), to: dayStart) {
            candidates.append(nextMorning)
        }
        
        for t in candidates where t > date {
            return t
        }
        
        return candidates.last ?? calendar.date(byAdding: DateComponents(day: 1, hour: 6), to: dayStart)!
    }
}
