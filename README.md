# ReportTableAdapterDemo

This iOS app demonstrates a technique for solving a iOS TableView which displays a fairly complex banking report scene. The technique involves transforming the input into a simple structure which can be easily displayed by a tableView. This technique can be applied to many complex tableView display requirements.

The app also demonstrates an architecture which breaks up a potentially very Massive View Controller by introducing an Adapter Class. The Adapter acts as a data source for a TableView by  implementing the UITableViewDataSource and Delegate protocols. The Adapter also acts as a data sink for the output of the transformation by implementing the TransactionListTransformerOutput protocol