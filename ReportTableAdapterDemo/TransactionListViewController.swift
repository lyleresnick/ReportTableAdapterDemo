//  Copyright © 2017 Lyle Resnick. All rights reserved.

import UIKit

 class TransactionListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var adapter: TransactionListAdapter!
    
    private var grandTotal = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
    
        transformFromTwoSources()
    }

    private func transformFromTwoSources() {

        appendSection(transactions: authorizedData, title: "Authorized")
        appendSection(transactions: postedData, title: "Posted")
        adapter.appendGrandFooter( grandTotal: String(grandTotal) )
    }

    private func appendSection(transactions: [TransactionModel]?, title: String) {

        adapter.appendHeader( title: "\(title) Transactions" )

        if let transactions = transactions  {

            if transactions.count == 0 {
                adapter.appendMessage(message: "There are no \(title) Transactions in this period")
            }
            else {
                var i = 0
                var transaction = next(transactions: transactions, i: &i )
                var total = 0.0

                while transaction != nil  {

                    let curDate = transaction!.date
                    adapter.appendSubheader(date: curDate)
                    while transaction != nil && transaction!.date == curDate  {

                        var amount: String
                        if (transaction!.debit != "D") {
                            amount = "-" + transaction!.amount
                        }
                        else {
                            amount = transaction!.amount
                        }
                        total += Double(amount)!
                        adapter.appendDetail(description: transaction!.description, amount: amount )
                        transaction = next(transactions: transactions, i: &i )
                    }
                    adapter.appendSubfooter()
                }
                adapter.appendFooter(total: String(total) )
                grandTotal += total
            }
        }
        else {
            adapter.appendMessage(message: "\(title) Transactions are not currently available. You might want to call us and tell us what you think of that!")
        }
    }
    
    private func next(transactions: [TransactionModel], i: inout Int ) ->TransactionModel? {
        
        let transaction = ( i < transactions.count ) ? transactions[ i ] : nil
        i += 1
        return transaction
    }
}


