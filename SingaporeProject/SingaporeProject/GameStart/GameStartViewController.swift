//
//  GameStartViewController.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/28.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum GameType {
    case easy, middle, hard
}

enum ItemType {
    case macbook, watch, mixer
}

class GameStartViewController: UIViewController {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var easyView: UIView!
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var middleButton: UIButton!
    @IBOutlet weak var hardView: UIView!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    fileprivate(set) var viewModel = GameViewModel()
    fileprivate let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureButton()
        configureVM()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension GameStartViewController {
    
    private func configureUI() {
        
        switch viewModel.itemType.value {
        case .macbook:
            itemImageView.image = R.image.img_macbook()
            titleLabel.text = "MacBook Air 13"
        case .mixer:
            itemImageView.image = R.image.img_mixer()
            titleLabel.text = "Sencor Food Mixer"
        case .watch:
            itemImageView.image = R.image.img_watch()
            titleLabel.text = "CASIO G-SHOCK"
        }
        
        easyView.layer.cornerRadius = 12
        easyView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        easyView.layer.shadowOpacity = 0.2
        easyView.layer.shadowColor = UIColor.black.cgColor
        easyView.layer.shadowRadius = 2.0
        middleView.layer.cornerRadius = 12
        middleView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        middleView.layer.shadowOpacity = 0.2
        middleView.layer.shadowColor = UIColor.black.cgColor
        middleView.layer.shadowRadius = 2.0
        hardView.layer.cornerRadius = 12
        hardView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        hardView.layer.shadowOpacity = 0.2
        hardView.layer.shadowColor = UIColor.black.cgColor
        hardView.layer.shadowRadius = 2.0
    }
    
    private func configureButton() {
        
        easyButton
            .rx.tap
            .throttle(0.7, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let wself = self else { return }
                wself.viewModel.gameTypeTrigger.onNext(.easy)
            })
            .disposed(by: bag)
        
        middleButton
            .rx.tap
            .throttle(0.7, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let wself = self else { return }
                wself.viewModel.gameTypeTrigger.onNext(.middle)
            })
            .disposed(by: bag)
        
        hardButton
            .rx.tap
            .throttle(0.7, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let wself = self else { return }
                wself.viewModel.gameTypeTrigger.onNext(.hard)
            })
            .disposed(by: bag)
        
        backButton
            .rx.tap
            .throttle(0.7, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let wself = self else { return }
                wself.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
    }
    
    func configureVM() {
        viewModel
            .gameType$
            .subscribe(onNext: { [weak self] gameType in
                guard let wself = self else { return }
                switch gameType {
                case .easy:
                    wself.easyView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                    wself.middleView.backgroundColor = .white
                    wself.hardView.backgroundColor = .white
                case .middle:
                    wself.middleView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                    wself.easyView.backgroundColor = .white
                    wself.hardView.backgroundColor = .white
                case .hard:
                    wself.hardView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                    wself.easyView.backgroundColor = .white
                    wself.middleView.backgroundColor = .white
                }
            })
            .disposed(by: bag)
    }
}
