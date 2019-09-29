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
    let gameScore$: Observable<Int>
    let dismissFlag$: Observable<Bool>
    let popFlag$: Observable<Bool>
    
    let gameType = Variable<GameType>(.easy)
    let itemType = Variable<ItemType>(.macbook)
    let gameScore = Variable<Int>(0)
    
    let gameTypeTrigger = PublishSubject<GameType>()
    let itemTypeTrigger = PublishSubject<ItemType>()
    let gameScoreTrigger = PublishSubject<Int>()
    let dismissFlagTrigger = PublishSubject<Bool>()
    let popFlagTrigger = PublishSubject<Bool>()
    
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
        
        gameScore$ = Observable
            .of(
                Observable.just(0),
                gameScoreTrigger.asObservable()
            )
            .concat()
            .share(replay: 1)
        
        dismissFlag$ = Observable
            .of(
                Observable.just(false),
                dismissFlagTrigger.asObservable()
            )
            .concat()
            .share(replay: 1)
        
        popFlag$ = Observable
            .of(
                Observable.just(false),
                popFlagTrigger.asObservable()
            )
            .concat()
            .share(replay: 1)
        
        gameType$
            .subscribe(onNext: { [weak self] type in
                guard let wself = self else { return }
                wself.gameType.value = type
            })
            .disposed(by: bag)
        
        itemType$
            .subscribe(onNext: { [weak self] type in
                guard let wself = self else { return }
                wself.itemType.value = type
            })
            .disposed(by: bag)
        
        gameScore$
            .subscribe(onNext: { [weak self] score in
                guard let wself = self else { return }
                wself.gameScore.value = score
            })
            .disposed(by: bag)
    }
}

extension GameViewModel {
    
    func addGameScore() {
        let newScore = gameScore.value + 10
        gameScoreTrigger.onNext(newScore)
    }
    
    func getImage(by itemType: ItemType) -> UIImage {
        switch itemType {
        case .macbook:
            return R.image.img_macbook() ?? UIImage()
        case .mixer:
            return R.image.img_mixer() ?? UIImage()
        case .watch:
            return R.image.img_watch() ?? UIImage()
        }
    }
}
