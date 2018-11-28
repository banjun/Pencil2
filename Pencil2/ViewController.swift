import UIKit
import NorthLayout

class ViewController: UIViewController, UITableViewDataSource {
    let canvas = Canvas()
    let debugTable = UITableView(frame: .zero, style: .plain)

    var lastTouch: UITouch? {
        didSet {debugTable.reloadData()}
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {fatalError()}

    override func viewDidLoad() {
        super.viewDidLoad()

        let autolayout = northLayoutFormat([:], ["canvas": canvas, "debug": debugTable])
        autolayout("H:|[debug(==320)][canvas]|")
        autolayout("V:|[debug]|")
        autolayout("V:|[canvas]|")

        debugTable.dataSource = self

        canvas.onTouchesChange = {[unowned self] in self.lastTouch = $0}
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Phase"
            cell.detailTextLabel?.text = lastTouch.map {"\($0.phase.rawValue)"}
        case 1:
            cell.textLabel?.text = "Force"
            cell.detailTextLabel?.text = lastTouch.map {String(format: "%.2f / %.2f", $0.force,$0.maximumPossibleForce)}
        case 2:
            cell.textLabel?.text = "Location"
            cell.detailTextLabel?.text = lastTouch.map {"\($0.location(in: canvas))"}
        case 3:
            cell.textLabel?.text = "Precise Location"
            cell.detailTextLabel?.text = lastTouch.map {"\($0.preciseLocation(in: canvas))"}
        case 4:
            cell.textLabel?.text = "Major Radius"
            cell.detailTextLabel?.text = lastTouch.map {String(format: "%.2f +/- %.2f", $0.majorRadius,$0.majorRadiusTolerance)}
        case 5:
            cell.textLabel?.text = "Azimuth Angle"
            cell.detailTextLabel?.text = lastTouch.map {String(format: "%.2f", $0.azimuthAngle(in: canvas) / .pi * 180)}
        case 6:
            cell.textLabel?.text = "Altitude Angle"
            cell.detailTextLabel?.text = lastTouch.map {String(format: "%.2f", $0.altitudeAngle / .pi * 180)}
        default:
            break
        }
        return cell
    }
}

