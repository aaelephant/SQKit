////
////  SQCollectionViewDelegate.swift
////  SQCollectionDemo
////
////  Created by qbshen on 16/6/13.
////  Copyright © 2016年 qbshen. All rights reserved.
////
//
//import UIKit
//
//class SQCollectionViewDelegate: NSObject ,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    var sectionDataDic = NSMutableDictionary()
//    
//    func loadData(originData:NSMutableDictionary) -> Void {
//        sectionDataDic = originData;
//    }
//    
//    func kSection(section:NSInteger) -> NSString {
//        return NSString(format: "%ld", section)
//    }
//    
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return sectionDataDic.count
//    }
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let sectionInfo = sectionDataDic[kSection(section)]
//        return (sectionInfo?.cellDataArray.count)!
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let sectionInfo = sectionDataDic[kSection(indexPath.section)]
//        let cellInfo = sectionInfo?.cellDataArray[indexPath.row] as! SQCollectionViewBaseInfo
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier((cellInfo.cellNibName) as String, forIndexPath: indexPath) as! SQCollectionViewBaseCell;
//        cell.fillData(cellInfo)
//        return cell
//    }
//    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        let sectionInfo = sectionDataDic[kSection(indexPath.section)]
//        let cellInfo = sectionInfo?.cellDataArray[indexPath.row]
//        if ((cellInfo?.gotoNextBlock) != nil) {
//            cellInfo?.gotoNextBlock
//        }
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSizeMake(100, 100)
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 10
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 10
//    }
//    
//    
//}
//
//class SQCollectionViewSectionInfo : NSObject {
//    
//    
//    var headViewInfo = SQCollectionViewHeadViewInfo()
//    var footViewInfo = SQCollectionViewFootViewInfo()
//    
//    var cellDataArray = NSMutableArray()
//}
//
//class SQCollectionViewBaseInfo : NSObject {
//    var cellNibName = NSString()
//    var cellClassName = NSString()
//    var cellStyle = UITableViewCellStyle.Default
//    var cellIndex = NSInteger()
//    ///  这是一个函数闭包变量
//    typealias  myfunction = (args:AnyObject) ->Void;
//    //  定义函数变量
//    var gotoNextBlock = myfunction?()
//}
//
//class SQCollectionViewHeadViewInfo : SQCollectionViewBaseInfo {
//    
//}
//
//class SQCollectionViewFootViewInfo : SQCollectionViewBaseInfo {
//    
//}
//
//class SQCollectionViewCellInfo : SQCollectionViewBaseInfo{
//
//}
//
////@objc(SQCollectionViewBaseCell)
////@objc
//class SQCollectionViewBaseCell: SQCollectionViewCellOC {
//    
//    func fillData(info:SQCollectionViewBaseInfo) -> Void {
//        
//    }
//    
//    override func select(sender: AnyObject?) {
//        NSLog("aa")
//    }
//}