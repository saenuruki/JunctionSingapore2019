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
    
    init() {
        
        dismissFlag$ = Observable
            .of(
                Observable.just(false),
                dismissFlagTrigger.asObservable()
            )
            .concat()
            .share(replay: 1)
    }
}

extension CameraViewModel {
    
}
