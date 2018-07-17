//
//  BlockInfoViewController.swift
//  EosDemo
//
//  Created by floatingpoint on 7/16/18.
//  Copyright © 2018 HologramPacific. All rights reserved.
//

import UIKit

class BlockInfoViewController: UIViewController {
    var blockInfo: BlockInfo? = nil

    @IBOutlet weak var wideTextView: UITextView!
    
    @IBOutlet weak var transactionsButton: UIButton!
    
    @IBAction func onTransactionButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let info = blockInfo else {
            return
        }
        let nl = "\n"
        let nlnl = "\n\n"
        let text = [
            "ID: ",  nl, info.id, nlnl,
            
            "Block Number: ", String(info.blockNum), nl,
            "Ref Block Prefix: ", String(info.refBlockPrefix), nl,
            "Time Stamp: ", info.timestamp, nl,
            "Schedule Version: ", String(info.scheduleVersion), nl,
            "Confirmed: ", String(info.confirmed), nl,
            "Transactions (count): ", String(info.transactions.count), nlnl,
            
            "Producer: ", info.producer, nl,
            "Producer Signature: ", nl, info.producerSignature, nlnl,

            "Previous: ", nl, info.previous, nlnl,
            "Transaction Merckle Root: ", nl, info.transactionMerckleRoot, nlnl,
            "Action Merckle Root: ", nl, info.actionMerckleRoot, nlnl
        ]
        
        wideTextView.text = text.joined()
        
        transactionsButton.isEnabled = info.transactions.count > 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
