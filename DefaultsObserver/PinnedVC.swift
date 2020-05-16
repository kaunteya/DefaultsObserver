import Cocoa
import Combine

class PinnedVC: NSViewController {
    var storage = Set<AnyCancellable>()

    @IBOutlet var tableView: NSTableView!
    var bundle: BundleID? {
        didSet {
            self.view.window!.title = bundle!.id// ?? ""
        }
    }

    var keys = [String]() {
        didSet {
            print("KEys updated \(keys)")
            bundle?.reload()
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        Timer.publish(every: 0.5, on: .main, in: .default)
//            .autoconnect()
//            .sink {_ in
//                self.tableView.reloadData()
//        }
//        .store(in: &self.storage)
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let vc = segue.destinationController as? ViewController {
            vc.bundle = bundle
            vc.selectedKeysSubject
                .sink { [unowned self] a in
                    self.keys = Array(Set((self.keys + a))).sorted()
            }
            .store(in: &self.storage)
        }
    }
}

extension PinnedVC: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        keys.count
    }


    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableColumn?.identifier.rawValue == "key" {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell1"), owner: nil) as! NSTableCellView
            cell.textField?.stringValue = keys[row]
            return cell
        } else {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell1"), owner: nil) as! NSTableCellView
            let val = keys[row]
            cell.textField?.stringValue = "\(val)"
            return cell
        }
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        30
    }
}
