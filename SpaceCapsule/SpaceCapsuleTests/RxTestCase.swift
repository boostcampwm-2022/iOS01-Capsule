//
//  RxTestCase.swift
//  SpaceCapsuleTests
//
//  Created by 장재훈 on 2023/01/09.
//

import RxCocoa
import RxRelay
import RxSwift
import RxTest
import XCTest

class RxTestCase<T>: BaseTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    private var resultObserver: TestableObserver<T>!

    var eventsToObserve: Observable<T> = .empty() {
        didSet {
            disposeBag = DisposeBag()
            scheduler = TestScheduler(initialClock: 0)
            resultObserver = scheduler.createObserver(T.self)

            eventsToObserve
                .bind(to: resultObserver)
                .disposed(by: disposeBag)
        }
    }

    func when(observing events: Observable<T>, _ task: () -> Void) {
        eventsToObserve = events
        task()
        executeEvents()
    }

    func createEvents<U>(_ events: [Recorded<Event<U>>], to relay: PublishRelay<U>) {
        scheduler
            .createHotObservable(events)
            .bind(to: relay)
            .disposed(by: disposeBag)
    }

    func createEvents<U>(_ events: [Recorded<Event<U>>], to subject: PublishSubject<U>) {
        scheduler
            .createHotObservable(events)
            .bind(to: subject)
            .disposed(by: disposeBag)
    }

    func executeEvents(advanceTo futureTime: VirtualTimeScheduler<TestSchedulerVirtualTimeConverter>.VirtualTime = 10) {
        scheduler.start()
        scheduler.advanceTo(futureTime)
        scheduler.stop()
    }
}
