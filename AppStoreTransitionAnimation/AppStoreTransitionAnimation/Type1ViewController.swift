//
//  Type1ViewController.swift
//  AppStoreTransitionAnimation
//
//  Created by Razvan Chelemen on 15/05/2019.
//  Copyright © 2019 appssemble. All rights reserved.
//

import UIKit
import AppstoreTransition

class Type1ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentCoverViewTop: NSLayoutConstraint!
    
    var dismissAnimationFinishedAction: (()->())?
    
    lazy var headerView: Type1HeaderView = {
        let view = UINib(nibName: "Type1HeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! Type1HeaderView
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.clipsToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ItemTableViewCell")
        
        positionHeaderView()
        
        tableView.contentOffset = CGPoint(x: 0, y: 50)
        
        headerView.topContainerView.backgroundColor = UIColor(named: "type1color")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        positionHeaderView()
    }
    
    private func positionHeaderView() {
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        headerView.frame.size = size
        tableView.tableHeaderView = headerView
    }
    
}

extension Type1ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath)
        
        return cell
    }
    
}

extension Type1ViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dismissHandler.scrollViewDidScroll(scrollView)
        
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = .zero
        }
    }
    
}

extension Type1ViewController: CardDetailViewController {

    var cardContentView: UIView {
        return headerView
    }
    
    var scrollView: UIScrollView {
        return tableView
    }
    
    func didStartPresentAnimationProgress() {
        tableView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    func didFinishDismissAnimation() {
        dismissAnimationFinishedAction?()
    }
    
    func didChangeDismissAnimationProgress(progress: CGFloat) {
        if (progress >= 0 && progress <= 1) {
            commentCoverViewTop.constant = -64 * progress
        }
    }
    
    func didCancelDismissAnimation(progress: CGFloat) {
        if progress < 1.0 {
            commentCoverViewTop.constant = 0
            tableView.setContentOffset(.zero, animated: true)
            
            UIView.animate(withDuration: 0.2) {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        }
    }
    
}
