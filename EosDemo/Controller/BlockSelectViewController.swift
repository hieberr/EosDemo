//
//  BlockSelectViewController.swift
//  EosDemo
//
//  Created by floatingpoint on 7/16/18.
//  Copyright © 2018 HologramPacific. All rights reserved.
//

import UIKit

class BlockSelectViewController: UIViewController {

    var currentChainInfoRequest: ChainInfoRequest? = nil
    var currentBlockInfoRequest: BlockInfoRequest? = nil

    @IBAction func OnShowHeadBlockButton(_ sender: UIButton) {
        currentChainInfoRequest = ChainInfoRequest(url: URL(string: "https://api.eosnewyork.io/v1/chain/get_info")!)
        currentChainInfoRequest?.load(withCompletion: {[weak self] info in
            guard let chainInfo = info else {
                // Error loading the chain info.
                // TODO: Post an error message.
                return
            }
            self?.currentBlockInfoRequest = BlockInfoRequest(url: URL(string: "https://api.eosnewyork.io/v1/chain/get_block")!, blockId: chainInfo.headBlockId)
            self?.currentChainInfoRequest = nil
            
            self?.currentBlockInfoRequest?.load(withCompletion: {[weak self] info in
                self?.blockInfoToShow = info
                if info == nil {
                    // Error loading the block.
                    // TODO: Post an error message.
                    return
                }
                self?.performSegue(withIdentifier: "ShowBlockInfoSegue", sender: sender)
                self?.currentBlockInfoRequest = nil
            })
        })
    }
    
    var blockInfoToShow: BlockInfo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
