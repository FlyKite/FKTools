//
//  ViewReusable.swift
//  FKToolsDemo
//
//  Created by FlyKite on 2018/11/16.
//  Copyright © 2018 Doge Studio. All rights reserved.
//

import UIKit

protocol ViewReusable {
    static var reuseIdentifier: String { get }
}

extension ViewReusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ViewReusable { }

extension UICollectionReusableView: ViewReusable { }

extension UITableViewHeaderFooterView: ViewReusable { }

extension UITableView {
    
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        if Bundle.main.path(forResource: cellType.reuseIdentifier, ofType: "nib") != nil {
            self.register(UINib(nibName: cellType.reuseIdentifier, bundle: Bundle.main),
                          forCellReuseIdentifier: cellType.reuseIdentifier)
        } else {
            self.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        if let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T {
            return cell
        } else {
            fatalError("Dequeue cell failed at (row: \(indexPath.row), section: \(indexPath.section))")
        }
    }
    
    func register<T: UITableViewHeaderFooterView>(_ viewType: T.Type) {
        if Bundle.main.path(forResource: viewType.reuseIdentifier, ofType: "nib") != nil {
            self.register(UINib(nibName: viewType.reuseIdentifier, bundle: Bundle.main),
                          forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
        } else {
            self.register(viewType, forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
        }
    }
    
    func dequeueReusableView<T: UITableViewHeaderFooterView>(_ viewType: T.Type) -> T? {
        return self.dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseIdentifier) as? T
    }
    
}

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ cellType: T.Type) {
        if Bundle.main.path(forResource: cellType.reuseIdentifier, ofType: "nib") != nil {
            self.register(UINib(nibName: cellType.reuseIdentifier, bundle: Bundle.main),
                          forCellWithReuseIdentifier: cellType.reuseIdentifier)
        } else {
            self.register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        if let cell = self.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T {
            return cell
        } else {
            fatalError("Dequeue cell failed at (item: \(indexPath.item), section: \(indexPath.section))")
        }
    }
    
}
