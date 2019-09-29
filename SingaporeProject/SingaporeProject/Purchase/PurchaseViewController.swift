//
//  PurchaseViewController.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/29.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PurchaseViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
//        tableView.register(R.nib.postConfirmMainTableCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PurchaseViewController {
    
    private func configureUI() {
        tableView.separatorStyle = .none
    }
}

extension PurchaseViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // TODO: - とりあえず
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.postConfirmMainTableCell, for: indexPath) else { return UITableViewCell() }
//        cell.configure(viewModel: viewModel)
//        cell.selectionStyle = .none
//        postConfirmMainTableCell = cell
//        cell.toggleKeyboardHandler = { [weak self] in
//            guard let wself = self else { return }
//            wself.toggleKeyboard()
//        }
//        return cell
        
        return UITableViewCell()
    }
}

extension PurchaseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapしたよ")
    }
    
    // 今後計算したい
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
}
