//
//  WalletViewController.swift
//  RealmCachingDemo
//
//  Created by Sam Watts on 19/07/2018.
//  Copyright © 2018 Curve. All rights reserved.
//

import UIKit
import RxSwift

class WalletViewController: UIViewController {

    let disposeBag = DisposeBag()

    let walletView = WalletView()

    let viewModel = WalletViewModel()

    override func loadView() {
        view = walletView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }

    private func setupBindings() {

        viewModel.walletItems
            .bind(to: walletView.tableView.rx.items(cellIdentifier: "cell")) { (_, walletItem: WalletItem, cell: UITableViewCell) in
                cell.textLabel?.text = walletItem.name
            }
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.refresh()
    }

}
