//
//  ViewController.swift
//  Shinagawa.Swift
//
//  Created by Kazuya Ueoka on 2017/01/22.
//  Copyright © 2017年 fromKK. All rights reserved.
//

import UIKit
import SafariServices

class EventViewCell: UITableViewCell, ReusableTableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    private var didSetup: Bool = false
    private func setup() {
        guard !self.didSetup else { return }
        
        self.accessibilityIdentifier = "eventViewCell"
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.dateLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 16.0),
            NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -16.0),
            NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 8.0),
            NSLayoutConstraint(item: self.dateLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 3.0),
            NSLayoutConstraint(item: self.dateLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 16.0),
            NSLayoutConstraint(item: self.dateLabel, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -16.0),
            NSLayoutConstraint(item: self.dateLabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: -8.0),
            ])
        
        self.didSetup = true
    }
    
    var event: ConnpassEvent? {
        didSet {
            self.titleLabel.text = self.event?.title
            self.dateLabel.text = self.event?.startedAt
        }
    }
    
    lazy var titleLabel: UILabel = { () -> UILabel in
        let label: UILabel = UILabel(frame: CGRect.zero)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byCharWrapping
        label.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.accessibilityIdentifier = "titleLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateLabel: UILabel = { () -> UILabel in
        let label: UILabel = UILabel(frame: CGRect.zero)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byCharWrapping
        label.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 10.0)
        label.textAlignment = NSTextAlignment.right
        label.accessibilityIdentifier = "dateLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

class EventsDataSource: NSObject, UITableViewDataSource {
    enum Constants {
        static let seriesId: Int = 919
    }
    
    let api: ConnpassAPI = ConnpassAPI()
    var search: ConnpassQuery {
        var query: ConnpassQuery = ConnpassQuery()
        query.seriesId(Constants.seriesId)
        return query
    }
    var events: [ConnpassEvent] = []
    weak var tableView: UITableView?
    
    func fetch() {
        self.api.search(self.search, completion: { [weak self] (events: [ConnpassEvent]) in
            self?.events = events
            self?.tableView?.reloadData()
        }) { (error: Error?) in
            if let error = error {
                print(error)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventViewCell = EventViewCell.reuseCell(with: tableView, indexPath: indexPath)
        cell.event = self.events[indexPath.row]
        return cell
    }
    
    func event(indexPath: IndexPath) -> ConnpassEvent? {
        guard self.events.indices.contains(indexPath.row) else { return nil }
        return self.events[indexPath.row]
    }
}

class ViewController: UIViewController {

    class HeaderView: UITableViewHeaderFooterView {
        static let reuseIdentifier: String = "HeaderView"
        
        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            
            self.setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
            self.setup()
        }
        
        lazy var imageView: UIImageView = { () -> UIImageView in
            let imageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
            imageView.contentMode = UIViewContentMode.scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        private var didSetup: Bool = false
        private func setup() {
            guard !self.didSetup else { return }
            
            self.translatesAutoresizingMaskIntoConstraints = false
            self.clipsToBounds = true
            self.accessibilityIdentifier = "headerView"
            self.contentView.addSubview(self.imageView)
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: self.imageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self.imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self.imageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self.imageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0),
                ])
            
            self.didSetup = true
        }
    }
    
    lazy var tableView: UITableView = { () -> UITableView in
        let tableView: UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.register(EventViewCell.self, forCellReuseIdentifier: EventViewCell.cellIdentifier)
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderView.reuseIdentifier)
        self.dataSource.tableView = tableView
        tableView.dataSource = self.dataSource
        tableView.delegate = self
        tableView.accessibilityIdentifier = "tableView"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var dataSource: EventsDataSource = EventsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.accessibilityIdentifier = "ViewController.view"
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0),
            ])
        self.dataSource.fetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        guard let url: URL = self.dataSource.event(indexPath: indexPath)?.eventUrl else { return }
        let viewController: SFSafariViewController = SFSafariViewController(url: url)
        self.present(viewController, animated: true, completion: nil)
    }
}
