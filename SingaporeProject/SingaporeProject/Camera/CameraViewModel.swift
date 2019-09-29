//
//  CameraViewModel.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/28.
//  Copyright © 2019 塗木冴. All rights reserved.
//


import UIKit

import RxSwift
import RxCocoa

class CameraViewModel {
    
    let bag = DisposeBag()
    
    let dismissFlag$: Observable<Bool>
    let dismissFlagTrigger = PublishSubject<Bool>()
    
    let itemType$: Observable<ItemType>
    let itemType = Variable<ItemType>(.macbook)
    let itemTypeTrigger = PublishSubject<ItemType>()
    
    init() {
        
        dismissFlag$ = Observable
            .of(
                Observable.just(false),
                dismissFlagTrigger.asObservable()
            )
            .concat()
            .share(replay: 1)
        
        itemType$ = Observable
            .of(
                Observable.just(.macbook),
                itemTypeTrigger.asObservable()
            )
            .concat()
            .share(replay: 1)
        
        itemType$
            .subscribe(onNext: { [weak self] itemType in
                guard let wself = self else { return }
                wself.itemType.value = itemType
            })
            .disposed(by: bag)
    }
}

extension CameraViewModel {
    
    func detectItemType(by predicts: [String]) {
        
        predicts.forEach { predictCategory in
            if predictCategory.contains("notebook") {
                itemTypeTrigger.onNext(.macbook)
            }
            else if predictCategory.contains("computer") {
                itemTypeTrigger.onNext(.macbook)
            }
            else if predictCategory.contains("laptop") {
                itemTypeTrigger.onNext(.macbook)
            }
            else if predictCategory.contains("digital") {
                itemTypeTrigger.onNext(.watch)
            }
            else if predictCategory.contains("watch") {
                itemTypeTrigger.onNext(.watch)
            }
            else if predictCategory.contains("glasses") {
                itemTypeTrigger.onNext(.watch)
            }
            else {
                itemTypeTrigger.onNext(.macbook)
            }
        }
    }
}
