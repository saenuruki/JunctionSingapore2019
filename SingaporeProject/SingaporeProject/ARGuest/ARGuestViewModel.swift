//
//  ARGuestViewModel.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/27.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import ObjectMapper

class ARGuestViewModel {
    
    let bag = DisposeBag()
    
    let anchorIDs$: Observable<[String]>
    let arObjects$: Observable<[ARObject]>
    let events$: Observable<[Event]>
    
    let anchorIDs = Variable<[String]>([])
    let arObjects = Variable<[ARObject]>([])
    let events = Variable<[Event]>([])
    
    let anchorIDsTrigger = PublishSubject<[String]>()
    let arObjectsTrigger = PublishSubject<[ARObject]>()
    let eventsTrigger = PublishSubject<[Event]>()
    
    init() {
        
        anchorIDs$ = Observable
            .of(
                Observable.just([]),
                anchorIDsTrigger.asObservable()
            )
            .concat()
            .share(replay: 1)
        
        arObjects$ = Observable
            .of(
                Observable.just([]),
                arObjectsTrigger.asObservable()
            )
            .concat()
            .share(replay: 1)
        
        events$ = Observable
            .of(
                Observable.just([]),
                eventsTrigger.asObservable()
            )
            .concat()
            .share(replay: 1)
        
        anchorIDs$
            .subscribe(onNext: { [weak self] anchorIDs in
                guard let wself = self else { return }
                wself.anchorIDs.value = anchorIDs
            })
            .disposed(by: bag)
        
        arObjects$
            .subscribe(onNext: { [weak self] arObjects in
                guard let wself = self else { return }
                wself.arObjects.value = arObjects
            })
            .disposed(by: bag)
        
        events$
            .subscribe(onNext: { [weak self] events in
                guard let wself = self else { return }
                wself.events.value = events
            })
            .disposed(by: bag)
    }
}

extension ARGuestViewModel {
    
    func addAnchor(with arObject: ARObject) {
        anchorIDs.value.append(arObject.cloudAnchorID)
        anchorIDsTrigger.onNext(anchorIDs.value)
        
        arObjects.value.append(arObject)
        arObjectsTrigger.onNext(arObjects.value)
    }
    
    func addNewAnchorID(with id: String, cloudAnchorID: String) {
        let newARObjects: [ARObject] = arObjects.value
        newARObjects.forEach {
            if $0.cloudAnchorID == cloudAnchorID {
                $0.anchorID = id
            }
        }
        arObjectsTrigger.onNext(newARObjects)
    }
    
    func getEvents() {
        let events: [Event] = Mapper<Event>().mapArray(JSONArray: eventsSample)
        eventsTrigger.onNext(events)
    }
    
    func searchEvent(from arAnchorID: String) -> Event {
        let arObject = searchARObject(from: arAnchorID)
        var targetObject: Event = Event()
        events.value.forEach {
            if $0.id == arObject.eventID {
                targetObject = $0
            }
        }
        return targetObject
    }
    
    func searchARObject(from arAnchorID: String) -> ARObject {
        var targetObject: ARObject = ARObject()
        arObjects.value.forEach {
            if $0.anchorID == arAnchorID {
                targetObject = $0
            }
        }
        return targetObject
    }
}
