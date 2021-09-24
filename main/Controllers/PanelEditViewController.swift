//
//  PanelEditViewController.swift
//  main
//
//  Created by kikurage on 2021/09/24.
//

import UIKit

class PanelEditViewController: UIViewController {

    @IBOutlet weak var rankingPanelBaseView: UIView!
    
    var rankingPanelView: RankingPanelView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rankingPanelView = RankingPanelView.instantiate()
        rankingPanelBaseView.addSubview(rankingPanelView)
        rankingPanelView.centeringAuto()
    }
}
