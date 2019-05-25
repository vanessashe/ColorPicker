//
//  ColorCollectionViewController.swift
//  ReadColor
//
//  Created by shelin on 2019/2/6.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

class ColorCollectionViewController: UIViewController {
    private let cellID = "ColorInfoCell"
    private var deleteSet:[MyColor] = []
    private let normalBackground = 0xFBFBFB.utils.asRGB
    private let darkBackground = 0xD0D9E4.utils.asRGB
    private var currentColorIndex = 0
    private var currentColor: MyColor? {
        get {
            if currentColorIndex > myColors.count - 1 {
                return nil
            }
            return myColors[currentColorIndex]
        }
    }
//    var deleteIndex:[Int] = []
    var myColors:[MyColor] = []
    weak var delegate: ColorSetViewControllerDelegate?
    
    var state: SelectionState = .normal {
        didSet {
            collectionView.allowsMultipleSelection = state == .delete
        }
    }
    enum SelectionState {
        case normal
        case delete
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
    }

    private func configCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = normalBackground
        collectionView.alwaysBounceVertical = true
        collectionView.utils.registCell(with: cellID)
        configLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    private func configLayout() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        let margin:CGFloat = screenWidth * 11.0/375.0
        collectionView.contentInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        
        let w = (screenWidth - 3 * margin)/2
        let h = max(w * 2/3 - 10,100)
    
        layout.itemSize = CGSize(width: w, height: h)
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
    }
    
    func preDelete(_ willDelete: Bool) {
    
        collectionView.backgroundColor = willDelete ? darkBackground : normalBackground
        deleteSet.removeAll()
        
    }
    func delete() {
    
        let colorSet = AppDelegate.colorSet
        colorSet.remove(colors: deleteSet)
        myColors = colorSet.getList()
        
        deleteSet.removeAll()
        collectionView.reloadData()
        state = .normal
        
    }
    
    func shouldDelete(color: MyColor) -> Bool {
        let preDeleteColor = deleteSet.first { (c) -> Bool in
            c.color == color.color
        }
        return preDeleteColor != nil
    }
    
}

extension ColorCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? ColorInfoCell else {
            return UICollectionViewCell()
        }
        let color = myColors[indexPath.row]
        cell.configUI(with: color, shouldDelete: shouldDelete(color: color))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row >= myColors.count {
            return
        }
        
        var color: MyColor
        color = myColors[indexPath.row]
        
        if state == .normal {
            currentColorIndex = indexPath.item
            delegate?.setPalette(color: color, colorInfoDelegate: self)
            
        } else if let cell = collectionView.cellForItem(at: indexPath) as? ColorInfoCell {
            cell.deletingMark.isHidden = false
            deleteSet.append(color)
            let feedback = UISelectionFeedbackGenerator()
            feedback.selectionChanged()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ColorInfoCell {
            cell.deletingMark.isHidden = true
            deleteSet = deleteSet.filter({ (c) -> Bool in
                c != myColors[indexPath.row]
            })
        }
    }
    
}

extension ColorCollectionViewController: ColorInfoDelegate {
    func rewrite(name: String) {
        currentColor?.name = name
        modifyColorSetAndRefreshCell()
    }
    
    func mark(liked: Bool) {
        myColors[currentColorIndex].isFavorite = liked
        modifyColorSetAndRefreshCell()
    }
    
    func modifyColorSetAndRefreshCell() {
        let colorset = AppDelegate.colorSet
        colorset.replace(with: myColors)
        
        if let cell = collectionView.cellForItem(at: IndexPath(item: currentColorIndex, section: 0)) as? ColorInfoCell {
            
            let color = myColors[currentColorIndex]
            cell.configUI(with: color, shouldDelete: shouldDelete(color: color))
        }
    }
}
