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
                print("=======================")
                print(itemType)
            })
            .disposed(by: bag)
    }
}

extension CameraViewModel {
    
    func detectItemType(by predicts: [String]) {
        
        predicts.forEach { predictCategory in
            if predictCategory.lowercased().contains("notebook") {
                itemTypeTrigger.onNext(.macbook)
                return
            }
//            else if predictCategory.contains("computer") {
//                itemTypeTrigger.onNext(.macbook)
//            }
            else if predictCategory.lowercased().contains("laptop") {
                itemTypeTrigger.onNext(.macbook)
                return
            }
            else if predictCategory.lowercased().contains("digital") {
                itemTypeTrigger.onNext(.watch)
                return
            }
            else if predictCategory.lowercased().contains("watch") {
                itemTypeTrigger.onNext(.watch)
                return
            }
            else if predictCategory.lowercased().contains("glasses") {
                itemTypeTrigger.onNext(.watch)
                return
            }
            else if predictCategory.lowercased().contains("mouse") {
                itemTypeTrigger.onNext(.watch)
                return
            }
            else if predictCategory.lowercased().contains("glasses") {
                itemTypeTrigger.onNext(.watch)
                return
            }
            else if predictCategory.lowercased().contains("belt") {
                itemTypeTrigger.onNext(.watch)
                return
            }
            else if predictCategory.lowercased().contains("glasses") {
                itemTypeTrigger.onNext(.watch)
                return
            }
        }
    }
}
