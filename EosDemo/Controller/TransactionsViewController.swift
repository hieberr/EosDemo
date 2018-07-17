//
//  TransactionsViewController.swift
//  EosDemo
//
//  Created by floatingpoint on 7/17/18.
//  Copyright © 2018 HologramPacific. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController {

    @IBOutlet weak var previousButton: UIButton!
    @IBAction func onPreviousButton(_ sender: UIButton) {
        currentIndex -= 1
    }
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func onNextButton(_ sender: UIButton) {
        currentIndex += 1
    }
    
    @IBOutlet weak var currentTransactionsLabel: UILabel!
    @IBOutlet weak var wideText: UITextView!
    
    var transactions: [TransactionHeader] = []
    
    private var _currentIndex = 0
    private var currentIndex: Int {
        get {
            return _currentIndex
        }
        set {
            if transactions.count != 0 {
                _currentIndex = min(max(newValue, 0), transactions.count - 1)
            }
            updateDisplay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if transactions.count == 0 {
            previousButton.isEnabled = false
            previousButton.isEnabled = false
        }
        currentIndex = 0
    }

    private func updateDisplay() {
        currentTransactionsLabel.text = String(currentIndex + 1) + " / " + String(transactions.count)
        
        if transactions.count == 0 {
            return
        }
        let t = transactions[currentIndex]
        
        let nl = "\n"
        let nlnl = "\n\n"
        var text = [
            "ID: ",  nl, t.trx.id, nlnl,
            "Status: ", t.status, nl,
            "CPU Usage: ", String(t.cpuUsageUs), nl,
            "Net Usage Words: ", String(t.netUsageWords), nl,
            "Compression: ", t.trx.compression, nl,
            "PackedTrx: ",  nl, t.trx.packedTrx, nlnl,
            "Signatures: ",  nl, "" + t.trx.signatures.joined(separator: "\n\n"), nlnl,
            "Packed Context Free Data: ",  nl, t.trx.packedContextFreeData, nl,
            
            "Delay(seconds): ", String(t.trx.transaction.delaySec), nl,
            "Expiration: ", t.trx.transaction.expiration, nl,
            "Max CPU Usage: ", String(t.trx.transaction.maxCpuUsageMs), nl,
            "Max Net Usage Words: ", String(t.trx.transaction.maxNetUsageWords), nl,
            "Ref Block Number: ", String(t.trx.transaction.refBlockNum), nl,
            "Ref Block Prefix: ", String(t.trx.transaction.refBlockPrefix), nlnl,
        ]
        var actions = "==== Actions ====" + nl
        let padding = "    "
        for action in t.trx.transaction.actions {
            var authString = ""
            var dataString = ""
            
            for auth in action.authorization {
                authString += [
                    padding, padding, "Actor: ", auth.actor, nl,
                    padding, padding, "Permission: ", auth.permission, nl
                ].joined()
            }
            if let data = action.data {
                if let value = data.from {
                    dataString += padding + padding + "From: " + value + nl
                }
                if let value = data.to {
                    dataString += padding + padding + "To: " + value + nl
                }
                if let value = data.quantity {
                    dataString += padding + padding + "Quantity: " + value + nl
                }
                if let value = data.memo {
                    dataString += padding + padding + "Memo: " + value + nl
                }
            }
            let actionString = [
                padding, "Account: ", action.account, nl,
                padding, "Name: ", action.name, nl,
                padding, "Hex Data: ", action.hexData, nlnl,
                padding, "Authorization: ", nl, authString, nl,
                padding, "Data: ", nl, dataString, nl
            ]
            
            actions.append(contentsOf: actionString.joined())
        }

        text.append(actions)
        wideText.text = text.joined()
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
