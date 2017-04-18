//  Copyright © 2017 Lyle Resnick. All rights reserved.

import UIKit

 class TransactionListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var adapter: TransactionListAdapter!
    
    private var grandTotal = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
    
        transformFromTwoStreams()
    }

    private func transformFromTwoStreams() {

        appendSection(transactions: authorizedData, title: "Authorized")
        appendSection(transactions: postedData, title: "Posted")
        adapter.appendGrandFooter( grandTotal: String(grandTotal) )
    }

    private func appendSection(transactions: [TransactionModel]?, title: String) {

        adapter.appendHeader( title: "\(title) Transactions" )

        if let transactions = transactions  {

            var i = 0
            var curTransaction = ( i < transactions.count ) ? transactions[ i ] : nil
            i += 1
            var total = 0.0

            while curTransaction != nil  {

                let curDate = curTransaction!.date
                adapter.appendSubheader(date: curDate)
                while curTransaction != nil && curTransaction!.date == curDate  {

                    var amount: String
                    if (curTransaction!.debit != "D") {
                        amount = "-" + curTransaction!.amount
                    }
                    else {
                        amount = curTransaction!.amount
                    }
                    total += Double(amount)!
                    adapter.appendDetail(description: curTransaction!.description, amount: amount )
                    curTransaction = ( i < transactions.count ) ? transactions[ i ] : nil
                    i += 1
                }
                adapter.appendSubfooter()
            }
            adapter.appendFooter(total: String(total) )
            grandTotal += total
        }
        else {
            adapter.appendNotFoundMessage(message: "\(title) Transactions are not currently available. You might want to call us and tell us what you think of that!")
        }
    }
}


