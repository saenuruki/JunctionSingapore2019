//
//  GameFinishViewController.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/28.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GameFinishViewController: UIViewController {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    fileprivate private(set) weak var viewModel: GameViewModel!
    fileprivate let bag = DisposeBag()
    
    static func create(viewModel: GameViewModel) -> UIViewController {
        let vc = R.storyboard.gameFinish.instantiateInitialViewController()!
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension GameFinishViewController {
    
    private func configureUI() {
        switch viewModel.gameType.value {
        case .easy:
            priceLabel.text = "$ 5.00"
        case .middle:
            priceLabel.text = "$ 10.00"
        case .hard:
            priceLabel.text = "$ 50.00"
        }
        
        switch viewModel.itemType.value {
        case .macbook:
            itemImageView.image =  R.image.img_macbook()
            itemLabel.text = "MacBook Air 13"
        case .mixer:
            itemImageView.image =  R.image.img_mixer()
            itemLabel.text = "Sencor Food Mixer"
        case .watch:
            itemImageView.image =  R.image.img_watch()
            itemLabel.text = "CASIO G-SHOCK"
        case .marketing:
            itemImageView.image =  R.image.img_marketing()
            itemLabel.text = "Samsung Galaxy Watch"
        }
    }
    
    private func configureButton() {
        
        purchaseButton
            .rx.tap
            .throttle(0.7, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let wself = self else { return }
                print("tapしたよ")
            })
            .disposed(by: bag)
        
        backButton
            .rx.tap
            .throttle(0.7, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let wself = self else { return }
                wself.viewModel.popFlagTrigger.onNext(true)
                wself.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
    }
}
