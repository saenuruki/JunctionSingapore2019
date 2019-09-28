//
//  GameStartViewModel.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/28.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class GameViewModel {
    
    let bag = DisposeBag()
    
    let gameType$: Observable<GameType>
    let itemType$: Observable<ItemType>
    
    let gameType = Variable<GameType>(.easy)
    let itemType = Variable<ItemType>(.macbook)
    
    let gameTypeTrigger = PublishSubject<GameType>()
    let itemTypeTrigger = PublishSubject<ItemType>()

    
    init() {
        
        gameType$ = Observable
            .of(
                Observable.just(.easy),
                gameTypeTrigger.asObservable()
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
    }
}

extension GameViewModel {
    
}
