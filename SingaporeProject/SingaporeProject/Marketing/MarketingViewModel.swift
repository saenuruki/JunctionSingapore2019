//
//  MarketingViewModel.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/29.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class MarketingViewModel {
    
    let bag = DisposeBag()
    
    let itemType$: Observable<ItemType>
    
    let itemType = Variable<ItemType>(.macbook)
    
    let itemTypeTrigger = PublishSubject<ItemType>()
    
    init() {
        
        itemType$ = Observable
            .of(
                Observable.just(.macbook),
                itemTypeTrigger.asObservable()
            )
            .concat()
            .share(replay: 1)
        
        itemType$
            .subscribe(onNext: { [weak self] type in
                guard let wself = self else { return }
                wself.itemType.value = type
            })
            .disposed(by: bag)
    }
}

extension MarketingViewModel {
    
    func getImage(by itemType: ItemType) -> UIImage {
        switch itemType {
        case .macbook:
            return R.image.img_macbook() ?? UIImage()
        case .mixer:
            return R.image.img_mixer() ?? UIImage()
        case .watch:
            return R.image.img_watch() ?? UIImage()
        case .marketing:
            return R.image.img_marketing() ?? UIImage()
        }
    }
    
    func getText(by itemType: ItemType) ->  String {
        switch itemType {
        case .macbook:
            return "MacBook Air 13"
        case .mixer:
            return "Sencor Food Mixer"
        case .watch:
            return "CASIO G-SHOCK"
        case .marketing:
            return "Samsung Galaxy Watch"
        }
    }
}
