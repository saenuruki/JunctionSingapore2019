//
//  ARAdminViewModel.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/27.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import RxSwift
import RxCocoa
import ObjectMapper

class ARAdminViewModel {
    
    let bag = DisposeBag()
    
    let events$: Observable<[Event]>
    let queueEvents$: Observable<[Event]> // MEMO: - キューとして扱う
    let selectedEvent$: Observable<Event>
    
    let events = Variable<[Event]>([])
    let queueEvents = Variable<[Event]>([])
    let selectedEvent = Variable<Event>(Event())
    
    let eventsTrigger = PublishSubject<[Event]>()
    let queueEventsTrigger = PublishSubject<[Event]>()
    let selectedEventTrigger = PublishSubject<Event>()
    
    init() {
        
        events$ = Observable
            .of(
                Observable.just([]),
                eventsTrigger.asObservable()
            )
            .concat()
            .share(replay: 1)
        
        queueEvents$ = Observable
            .of(
                Observable.just([]),
                queueEventsTrigger.asObservable()
            )
            .concat()
            .share(replay: 1)
        
        
        selectedEvent$ = Observable
            .of(
                Observable.just(Event()),
                selectedEventTrigger.asObservable()
            )
            .concat()
            .share(replay: 1)
        
        events$
            .subscribe(onNext: { [weak self] events in
                guard let wself = self else { return }
                wself.events.value = events
            })
            .disposed(by: bag)
        
        queueEvents$
            .subscribe(onNext: { [weak self] events in
                guard let wself = self else { return }
                wself.queueEvents.value = events
            })
            .disposed(by: bag)
        
        selectedEvent$
            .subscribe(onNext: { [weak self] event in
                guard let wself = self else { return }
                wself.selectedEvent.value = event
            })
            .disposed(by: bag)
    }
}

extension ARAdminViewModel {
    
    func getEvents() {
        let events: [Event] = Mapper<Event>().mapArray(JSONArray: eventsSample)
        eventsTrigger.onNext(events)
        if let firstEvent = events.first {
            selectedEventTrigger.onNext(firstEvent)
        }
    }
    
//    func putARAnchor(by id: String) {
//        AWSRequest.putARAnchor(anchorID: id, eventID: selectedEvent.value.id)
//    }
    
    // MEMO: - ARオブジェクトを作成した際に選択しているイベントをキューのに入れる
    func putSelectedEvent() {
        queueEvents.value.append(selectedEvent.value)
        queueEventsTrigger.onNext(queueEvents.value)
    }
    
    func getSelectedEvent() ->  Event {
        let firstEvent = queueEvents.value.removeFirst()
        queueEventsTrigger.onNext(queueEvents.value)
        return firstEvent
    }
}
