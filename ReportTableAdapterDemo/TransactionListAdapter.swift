// Copyright © 2017 Cellarpoint. All rights reserved.

import UIKit

class TransactionListAdapter: NSObject {

    fileprivate var rowList = [Row]()
    fileprivate var odd = false
}

// MARK: - TransactionListTransformerOutput

extension TransactionListAdapter: TransactionListTransformerOutput {
    
    func appendHeader(title: String ) {
        rowList.append( HeaderRow( title: title ) )
    }

    private static let inboundDateFormat = DateFormatter.dateFormatter( format: "yyyy'-'MM'-'dd" )
    private static let outboundDateFormat = DateFormatter.dateFormatter( format: "MMM' 'dd', 'yyyy" )
    
    func appendSubheader(date inboundDate: String) {

        odd = !odd
        let date = TransactionListAdapter.inboundDateFormat.date( from: inboundDate)!
        let dateString = TransactionListAdapter.outboundDateFormat.string(from: date ).uppercased()
        rowList.append( SubheaderRow( title: dateString, odd: odd ) )
    }

    func appendDetail( description: String, amount: String ) {
        rowList.append( DetailRow( description: description, amount: amount, odd: odd ) )
    }

    func appendSubfooter() {
        rowList.append(SubfooterRow( odd: odd ))
    }

    func appendFooter(total: String) {
        
        odd = !odd
        rowList.append(FooterRow(total: total, odd: odd))
    }
    
    func appendGrandFooter(grandTotal: String) {
        
        rowList.append(GrandFooterRow(grandTotal: grandTotal))
    }
    
    func appendMessage(message: String) {
        rowList.append(MessageRow(message: message))
    }
}

// MARK: - Rows

private enum CellId: String {
    
    case header
    case subheader
    case detail
    case subfooter
    case footer
    case grandfooter
    case message
}

private protocol Row {
    var cellId: CellId { get }
}

private struct HeaderRow: Row {
    
    let title:  String
    let cellId: CellId = .header
}

private struct SubheaderRow: Row {
    
    let title:  String
    let odd: Bool
    let cellId: CellId = .subheader
}

private struct DetailRow: Row {
    
    let description: String
    let amount: String
    let odd: Bool
    let cellId: CellId = .detail
}

private struct SubfooterRow: Row {
    
    let odd: Bool
    let cellId: CellId = .subfooter
}

private struct FooterRow: Row {
    
    let total: String
    let odd: Bool
    let cellId: CellId = .footer
}

private struct GrandFooterRow: Row {
    
    let grandTotal: String
    let cellId: CellId = .grandfooter
}

private struct MessageRow: Row {
    
    let message: String
    let cellId: CellId = .message
}

// MARK: - UITableViewDataSource

extension TransactionListAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row  = rowList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.cellId.rawValue, for: indexPath)
        (cell  as! TransactionListCell).bind(row: row )
        return cell
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowList.count 
    }
}

// MARK: - Cells
// cell classes are internal because IB can't find them when they are private

private protocol TransactionListCell {
    func bind(row: Row)
}

private extension TransactionListCell where Self: UITableViewCell {
    
    func setBackgroundColour(odd: Bool) {
        
        let backgroundRgb = odd ? 0xF7F8FC : 0xDDDDDD
        backgroundColor = UIColor( rgb: backgroundRgb )
    }
}

class TransactionListHeaderCell: UITableViewCell, TransactionListCell {

    @IBOutlet private var titleLabel: UILabel!

    fileprivate func bind(row: Row) {
        
        let headerRow = row as! HeaderRow
        titleLabel.text = headerRow.title
    }
}

class TransactionListSubheaderCell: UITableViewCell, TransactionListCell {

    @IBOutlet private var titleLabel: UILabel!

    fileprivate func bind(row: Row) {

        let subheaderRow = row as! SubheaderRow
        titleLabel.text = subheaderRow.title
        setBackgroundColour(odd: subheaderRow.odd)
    }
}

class TransactionListDetailCell: UITableViewCell, TransactionListCell {

    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!

    fileprivate func bind(row: Row) {

        let detailRow = row as! DetailRow
        descriptionLabel.text = detailRow.description
        amountLabel.text = detailRow.amount
        setBackgroundColour(odd: detailRow.odd)
    }
}

class TransactionListSubfooterCell: UITableViewCell, TransactionListCell {

    fileprivate func bind(row: Row) {

        let subFooterRow = row as! SubfooterRow
        setBackgroundColour(odd: subFooterRow.odd)
    }
}

class TransactionListFooterCell: UITableViewCell, TransactionListCell {
    
    @IBOutlet private var totalLabel: UILabel!
    
    fileprivate func bind(row: Row) {
        
        let footerRow = row as! FooterRow
        totalLabel.text = footerRow.total
        setBackgroundColour(odd: footerRow.odd)
    }
}

class TransactionListGrandFooterCell: UITableViewCell, TransactionListCell {
    
    @IBOutlet private var totalLabel: UILabel!
    
    fileprivate func bind(row: Row) {
        
        let grandFooterRow = row as! GrandFooterRow
        totalLabel.text = grandFooterRow.grandTotal
    }
}

class TransactionListMessageCell: UITableViewCell, TransactionListCell {

    @IBOutlet private var messageLabel: UILabel!

    fileprivate func bind(row: Row) {

        let messageRow = row as! MessageRow
        messageLabel.text = messageRow.message
        setBackgroundColour(odd: true)
    }
}



