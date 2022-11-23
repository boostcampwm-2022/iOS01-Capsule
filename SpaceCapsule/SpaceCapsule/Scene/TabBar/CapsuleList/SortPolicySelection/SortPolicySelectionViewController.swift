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
    var dataSource: [SortPolicy] = [.nearest, .furthest, .latest, .oldest]
    let cellIdentifier: String = "cell"
    let tableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
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
        configure()
        addSubViews()
        makeConstraints()
        
        bind()
    }
    private func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SortPolicyCell.self, forCellReuseIdentifier: SortPolicyCell.identifier)
        tableView.register(SortPolicyHeaderView.self, forHeaderFooterViewReuseIdentifier: SortPolicyHeaderView.identifier)
    }
    
    private func addSubViews() {
        view.addSubview(tableView)
    }
    
    private func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    func bind() {}
}

extension SortPolicySelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SortPolicyCell.identifier, for: indexPath) as? SortPolicyCell else {
            return UITableViewCell()
        }
        cell.configure(sortPolicy: dataSource[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SortPolicyHeaderView.identifier) else {
            return UIView()
        }
        return header
    }
    
}
