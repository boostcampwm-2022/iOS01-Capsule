//
//  SortPolicySelectionViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/23.
//

import RxSwift
import UIKit

final class SortPolicySelectionViewController: UIViewController, BaseViewController {
    var disposeBag = DisposeBag()
    var viewModel: SortPolicySelectionViewModel?
    var dataSource: [String] = ["1", "2", "3"]
    let cellIdentifier: String = "cell"
    let tableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        return tableView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSheet()
        view = tableView
        tableView.delegate = self
        tableView.dataSource = self
        bind()
    }
    
    func bind() {}
    private func configureSheet() {
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.selectedDetentIdentifier = .medium
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }
    }
}

extension SortPolicySelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]

        return cell
    }
}
