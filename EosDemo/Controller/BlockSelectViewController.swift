//
//  BlockSelectViewController.swift
//  EosDemo
//
//  Created by floatingpoint on 7/16/18.
//  Copyright © 2018 HologramPacific. All rights reserved.
//

import UIKit

class BlockSelectViewController: UIViewController {

    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!

    @IBAction func onCancelButton(_ sender: Any) {
        resetStatusView()
    }
    
    @IBOutlet weak var connectionIndicator: UIActivityIndicatorView!
    
    var currentChainInfoRequest: ChainInfoRequest? = nil
    var currentBlockInfoRequest: BlockInfoRequest? = nil

    @IBAction func OnShowHeadBlockButton(_ sender: UIButton) {
        currentChainInfoRequest = ChainInfoRequest(url: URL(string: "https://api.eosnewyork.io/v1/chain/get_info")!)
        
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
            self?.currentBlockInfoRequest = BlockInfoRequest(url: URL(string: "https://api.eosnewyork.io/v1/chain/get_block")!, blockId: chainInfo.headBlockId)
            self?.currentChainInfoRequest = nil
            
            self?.statusLabel.text = "Retriving Block..."
            self?.connectionIndicator.startAnimating()
            self?.currentBlockInfoRequest?.load(withCompletion: {[weak self] info in
                self?.connectionIndicator.stopAnimating()
                self?.blockInfoToShow = info
                if info == nil {
                    // Error loading the block.
                    self?.statusLabel.text = "Error retrieving block information."
                    return
                }
                self?.resetStatusView()
                
                self?.performSegue(withIdentifier: "ShowBlockInfoSegue", sender: sender)
                self?.currentBlockInfoRequest = nil
            })
        })
    }
    
    var blockInfoToShow: BlockInfo? = nil
    
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
