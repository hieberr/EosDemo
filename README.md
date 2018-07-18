# EOS Demo

A simple app for viewing blocks on the EOS test network. In it's current form it's not pretty but it displays the information. In the future I would like to break up the information into seperate labels and text fields and format things a little nicer.

### Usage:
Press "Head Block" to display the most recent block on the chain. Or, enter the block ID or number that you would like to view and press "Go"

![Block Select](http://pub.hologrampacific.com/EosDemoImages/BlockSelect.jpg)

Once you are viewing a block you can view it's transactions (if it has any) by pressing the "Transactions" button.

![Block Info](http://pub.hologrampacific.com/EosDemoImages/BlockInfo.jpg)

If there are multiple transactions you can cycle through them by pressing the arrow at the top.

![Transactions](http://pub.hologrampacific.com/EosDemoImages/Transactions.jpg)

If a transaction has a ricardian contract it is rendered and appended to the bottom the transaction details. It seems fairly rare that blocks have ricardian contracts (or maybe I'm just getting the information incorrectly). For an example of a block that has a ricardian contract check out block number: 6233570

![TransactionsRicardian](http://pub.hologrampacific.com/EosDemoImages/TransactionsRicardian.jpg)

