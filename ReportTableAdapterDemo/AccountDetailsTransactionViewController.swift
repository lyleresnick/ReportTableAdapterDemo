//  Copyright © 2017 Lyle Resnick. All rights reserved.

import UIKit

 class AccountDetailsTransactionViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    let adapter = AccountDetailsTransactionListAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        initializeListView()
    }

    private func initializeListView() {

        initializeAdapter( adapter: adapter )
        tableView.dataSource = adapter
        tableView.delegate = adapter
    }

    private func initializeAdapter(adapter: AccountDetailsTransactionListAdapter ) {

        appendTransactions(adapter: adapter, transactions: authorizedData, title: "Authorized")
        appendTransactions(adapter: adapter, transactions: postedData, title: "Posted")
    }

    private func appendTransactions(  adapter: AccountDetailsTransactionListAdapter,  transactions: [TransactionModel]?, title: String ) {

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
        }
        else {
            adapter.appendMessage(message: "\(title) Transactions are not currently available. You might want to call us and tell us what you think of that!")
        }
    }
}


