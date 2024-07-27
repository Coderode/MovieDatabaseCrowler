//
//  SortView.swift
//  MovieDatabase
//
//  Created by Sandeep kushwaha on 26/07/24.
//

import Foundation
import UIKit

protocol SortListVCDelegate : AnyObject {
    func didSelectSortOption(option: Sort)
}

class SortView : UITableViewController {
    var data: [Sort] = []
    weak var delegate: SortListVCDelegate?
    
    class func instantiate(data: [Sort], delegate: SortListVCDelegate, popoverView: UIView) -> UIViewController {
        let vc = SortView()
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.height * 0.4)
        vc.delegate = delegate
        vc.data = data
        if let popoverController = vc.popoverPresentationController {
            popoverController.sourceView = popoverView
            popoverController.sourceRect = popoverView.bounds
            popoverController.permittedArrowDirections = .up
            popoverController.delegate = vc
        }
        return vc
    }
    
    override func viewDidLoad() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        self.preferredContentSize = CGSize(width: UIScreen.main.bounds.width * 0.45, height: self.calculateTableViewContentHeight())
        self.view.backgroundColor = .lightGray
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .lightGray
        cell.textLabel?.text = self.data[indexPath.row].title.capitalized
        cell.textLabel?.textColor = .black
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectSortOption(option: self.data[indexPath.row])
        self.dismiss(animated: true)
    }
    
    func calculateTableViewContentHeight() -> CGFloat {
        var totalHeight: CGFloat = 0.0
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                let height = tableView.delegate?.tableView?(tableView, heightForRowAt: indexPath) ?? 44.0
                totalHeight += height
            }
        }
        
        return totalHeight
    }
}

extension SortView: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
