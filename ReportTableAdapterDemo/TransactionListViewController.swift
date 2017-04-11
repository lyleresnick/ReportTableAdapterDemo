//  Copyright © 2017 Lyle Resnick. All rights reserved.

import UIKit

 class TransactionListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var adapter: TransactionListAdapter!
    
    private var grandTotal = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
    
        initializeFromTwoStreams()
    }

    private func initializeFromTwoStreams() {

        appendTransactions(transactions: authorizedData, title: "Authorized")
        appendTransactions(transactions: postedData, title: "Posted")
        adapter.appendGrandFooter( grandTotal: String(grandTotal) )
    }

    private func appendTransactions(transactions: [TransactionModel]?, title: String) {

        adapter.appendHeader( title: "\(title) Transactions" )

        if let transactions = transactions  {

            var i = 0
            var curTransaction = ( i < transactions.count ) ? transactions[ i ] : nil
            i += 1
            var total = 0.0

            while let localCurTransaction = curTransaction  {

                let curDate = localCurTransaction.date
                adapter.appendSubheader(date: curDate)
                while let localCurTransaction = curTransaction, localCurTransaction.date == curDate  {

                    var amount: String
                    if (localCurTransaction.debit != "D") {
                        amount = "-" + localCurTransaction.amount
                    }
                    else {
                        amount = localCurTransaction.amount
                    }
                    total += Double(amount)!
                    adapter.appendDetail(description: localCurTransaction.description, amount: amount )
                    curTransaction = ( i < transactions.count ) ? transactions[ i ] : nil
                    i += 1
                }
                adapter.appendSubfooter()
            }
            adapter.appendFooter(total: String(total) )
            grandTotal += total
        }
        else {
            adapter.appendMessage(message: "\(title) Transactions are not currently available. You might want to call us and tell us what you think of that!")
        }
    }
}


