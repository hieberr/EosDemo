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
    var currentRequest: RequestTask? = nil
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!

    @IBAction func onCancelButton(_ sender: Any) {
        if let task = currentRequest {
            task.cancel()
            currentRequest = nil
        }
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
        self.connectionIndicator.isHidden = false
        statusLabel.text = "Retriving Head Block ID..."
        connectionIndicator.startAnimating()
        currentRequest = currentChainInfoRequest?.load(withCompletion: {[weak self] info in
            self?.connectionIndicator.stopAnimating()
            self?.connectionIndicator.isHidden = true
            guard let chainInfo = info else {
                // Error loading the chain info.
                self?.statusLabel.text = "Error retrieving chain information."
                return
            }
            self?.loadBlockInfoFor(blockId: chainInfo.headBlockId)
            self?.currentChainInfoRequest = nil
        })
    }
    
    /// Attempts to load the block information (asynchronously) for a given block ID.
    /// On successful result it segues to the blockInfo viewController.
    /// - Parameter blockId: the block ID to fetch.
    func loadBlockInfoFor(blockId: String) {
        let url = networkUrl.appendingPathComponent("get_block")
        currentBlockInfoRequest = BlockInfoRequest(url: url, blockId: blockId)
        statusView.isHidden = false
        statusLabel.text = "Retriving Block..."
        self.connectionIndicator.isHidden = false
        connectionIndicator.startAnimating()
        currentRequest = currentBlockInfoRequest?.load(withCompletion: {[weak self] info in
            self?.connectionIndicator.stopAnimating()
            self?.connectionIndicator.isHidden = true
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

    /// Hides and resets the statusView.
    func resetStatusView() {
        statusLabel.text = ""
        connectionIndicator.stopAnimating()
        statusView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BlockInfoViewController {
            destination.blockInfo = blockInfoToShow
        }
    }
}
