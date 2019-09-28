//
//  GameFinishViewController.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/28.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import UIKit

class GameFinishViewController: UIViewController {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    private func configureButton() {
    }
}
