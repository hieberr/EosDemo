//
//  BlockSelectViewController.swift
//  EosDemo
//
//  Created by floatingpoint on 7/16/18.
//  Copyright © 2018 HologramPacific. All rights reserved.
//

import UIKit

class BlockSelectViewController: UIViewController {
    
    var blockInfoToShow: BlockInfo? = nil
    var currentChainInfoRequest: ChainInfoRequest? = nil
    var currentBlockInfoRequest: BlockInfoRequest? = nil
    let networkUrl = URL(string: "https://api.eosnewyork.io/v1/chain")!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!

    @IBAction func onCancelButton(_ sender: Any) {
        resetStatusView()
    }
    @IBOutlet weak var blockIdField: UITextField!
    
    @IBAction func onGoButton(_ sender: Any) {
        loadBlockInfoFor(blockId: blockIdField.text ?? "")
    }
    
    @IBOutlet weak var connectionIndicator: UIActivityIndicatorView!
    
    @IBAction func OnShowHeadBlockButton(_ sender: UIButton) {
        let url = networkUrl.appendingPathComponent("get_info")
        currentChainInfoRequest = ChainInfoRequest(url: url)
        
        statusView.isHidden = false
        statusLabel.text = "Connecting..."
        connectionIndicator.startAnimating()
        currentChainInfoRequest?.load(withCompletion: {[weak self] info in
            self?.connectionIndicator.stopAnimating()
            guard let chainInfo = info else {
                // Error loading the chain info.
                self?.statusLabel.text = "Error retrieving chain information"
                return
            }
            self?.loadBlockInfoFor(blockId: chainInfo.headBlockId)
        })
    }
    
    func loadBlockInfoFor(blockId: String) {
        let url = networkUrl.appendingPathComponent("get_block")
        currentBlockInfoRequest = BlockInfoRequest(url: url, blockId: blockId)
        currentChainInfoRequest = nil
        statusView.isHidden = false
        statusLabel.text = "Retriving Block..."
        connectionIndicator.startAnimating()
        currentBlockInfoRequest?.load(withCompletion: {[weak self] info in
            self?.connectionIndicator.stopAnimating()
            self?.blockInfoToShow = info
            if info == nil {
                // Error loading the block.
                self?.statusLabel.text = "Error retrieving block information."
                return
            }
            self?.resetStatusView()
            self?.performSegue(withIdentifier: "ShowBlockInfoSegue", sender: self)
            self?.currentBlockInfoRequest = nil
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetStatusView()
    }

    func resetStatusView() {
        statusLabel.text = ""
        connectionIndicator.stopAnimating()
        statusView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let destination = segue.destination as? BlockInfoViewController else {
            // Error
            return
        }
        destination.blockInfo = blockInfoToShow
    }
}
