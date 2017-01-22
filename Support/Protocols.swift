//
//  Protocols.swift
//  Shinagawa.Swift
//
//  Created by Kazuya Ueoka on 2017/01/22.
//  Copyright © 2017年 fromKK. All rights reserved.
//

import UIKit

protocol StoryboardInstantitable: class {
    static var storyboardName: String { get }
    static var viewControllerIdentifier: String { get }
}

extension StoryboardInstantitable {
    static func instantitate() -> Self {
        guard let result: Self = UIStoryboard(name: Self.storyboardName, bundle: Bundle(for: Self.self)).instantiateViewController(withIdentifier: Self.viewControllerIdentifier) as? Self else {
            fatalError("instantitate failed")
        }
        
        return result
    }
}

protocol XibInstantitable: class {
    static var nibName: String { get }
}

extension XibInstantitable {
    static func instantitate(with owner: Any? = nil) -> Self {
        guard let result: Self = UINib(nibName: Self.nibName, bundle: Bundle(for: Self.self)).instantiate(withOwner: owner, options: nil).first as? Self else {
            fatalError("instantitate failed")
        }
        
        return result
    }
}

// Localizables

protocol Localizable: RawRepresentable {
    var rawValue: String { get }
}

extension Localizable {
    func localize(table: String? = "Localizable", bundle: Bundle = Bundle.main) -> String {
        if nil == table {
            return NSLocalizedString(self.rawValue, comment: "")
        } else {
            return NSLocalizedString(self.rawValue, tableName: table, bundle: bundle, value: "", comment: "")
        }
    }
}

// Reusables

protocol ReusableCell: class {
    static var cellIdentifier: String { get }
}
extension ReusableCell {
    static var cellIdentifier: String {
        return String(describing: type(of: self))
    }
}

protocol ReusableTableViewCell: ReusableCell {}
protocol ReusableCollectionViewCell: ReusableCell {}

extension ReusableTableViewCell {
    static func reuseCell(with tableView: UITableView, indexPath: IndexPath) -> Self {
        guard let cell: Self = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath) as? Self else {
            fatalError("cell initialize failed")
        }
        return cell
    }
}

extension ReusableCollectionViewCell {
    static func reuseCell(with collectionView: UICollectionView, indexPath: IndexPath) -> Self {
        guard let cell: Self = collectionView.dequeueReusableCell(withReuseIdentifier: Self.cellIdentifier, for: indexPath) as? Self else {
            fatalError("cell initialize failed")
        }
        return cell
    }
}
