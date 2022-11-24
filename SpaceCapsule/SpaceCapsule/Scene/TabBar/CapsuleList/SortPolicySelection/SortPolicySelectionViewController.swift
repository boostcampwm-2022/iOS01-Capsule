//
//  SortPolicySelectionViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/23.
//

import RxSwift
import RxCocoa
import UIKit

final class SortPolicySelectionViewController: UIViewController, BaseViewController {
    var disposeBag = DisposeBag()
    var viewModel: SortPolicySelectionViewModel?
    var dataSource: [SortPolicy] = [.nearest, .furthest, .latest, .oldest]
    let cellIdentifier: String = "cell"
    var lastSortPolicy: SortPolicy = .nearest
    
    let tableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    init(lastSortPolicy: SortPolicy) {
        super.init(nibName: nil, bundle: nil)
        self.lastSortPolicy = lastSortPolicy
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
        viewModel?.input.sortPolicy.onNext(lastSortPolicy)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.input.viewWillDisappear.onNext(())
        super.viewWillDisappear(animated)
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
    
    func bind() {
        viewModel?.input.sortPolicy
            .withUnretained(self)
            .bind(onNext: { weakSelf, sortPolicy in
                if let row = weakSelf.dataSource.firstIndex(of: sortPolicy) {
                    weakSelf.tableView.selectRow(at: [0, row], animated: true, scrollPosition: .none)
                }
            })
            .disposed(by: disposeBag)
        tableView.rx.itemSelected
            .withUnretained(self)
            .bind { weakSelf, indexPath in
                let sortPolicy = weakSelf.dataSource[indexPath.row]
                weakSelf.viewModel?.input.sortPolicy.onNext(sortPolicy)
            }
            .disposed(by: disposeBag)
    }
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
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SortPolicyHeaderView.identifier) else {
            return UIView()
        }
        return header
    }
}
