//
//  SQTableViewDelegate.swift
//  SQTableViewKit
//
//  Created by qbshen on 16/9/8.
//  Copyright © 2016年 qbshen. All rights reserved.
//

import UIKit

class SQTableViewDelegate: NSObject, UITableViewDelegate,UITableViewDataSource {
    var canEdit:Bool = false
    
    var sectionDataDic = NSMutableDictionary()
    
    func loadData(originData:NSMutableDictionary) -> Void {
        sectionDataDic = originData
    }
    
    func kSection(section:NSInteger) -> NSString {
        return NSString(format: "%ld", section)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (sectionDataDic.count)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = sectionDataDic[kSection(section)]
        return (sectionInfo?.cellDataArray.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sectionInfo = sectionDataDic[kSection(indexPath.section)]
        
        let cellInfo = sectionInfo!.cellDataArray[indexPath.row] as! SQTableViewBaseInfo;
        cellInfo.indexPath = indexPath
        var cell = tableView.dequeueReusableCellWithIdentifier(cellInfo.cellNibName.isEmpty ? cellInfo.cellNibName : cellInfo.cellClassName);
        if (nil == cell) {
            cell = cellForSection(cellInfo , tableView: tableView)
        }
        (cell as! SQTableViewBaseCell).fillData(cellInfo );
        return cell!;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let sectionInfo = sectionDataDic[kSection(indexPath.section)]
        
        let cellInfo = sectionInfo!.cellDataArray[indexPath.row] as! SQTableViewBaseInfo;
        
        return cellInfo.cellHeight
    }
    
    func cellForSection(cellInfo:SQTableViewBaseInfo, tableView:UITableView) -> SQTableViewBaseCell {
        var cell = SQTableViewBaseCell()
        let nibName = cellInfo.cellNibName
        let className = cellInfo.cellClassName
        if nibName.isEmpty && nibName.characters.count != 0 {
            cell = loadNibCellWithNibName(nibName, tableView: tableView, reuseIdentifier: nibName)
        }else{
            cell = swiftCellClassFromString(className, cellStyle: cellInfo.cellStyle, reuseIdentifier: className) as! SQTableViewBaseCell
        }
        return cell
    }
    
    func loadNibCellWithNibName(nibName:String, tableView:UITableView, reuseIdentifier: String) -> SQTableViewBaseCell {
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        return tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! SQTableViewBaseCell
    }
    
    func swiftCellClassFromString(className: String, cellStyle:UITableViewCellStyle, reuseIdentifier: String) -> UITableViewCell! {
        // get the project name
        if  let appName: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String? {
            //拼接控制器名
            let classStringName = "\(appName).\(className)"
            //将控制名转换为类
            let classType = NSClassFromString(classStringName) as? UITableViewCell.Type
            if let type = classType {
                let newCell = type.init(style: cellStyle, reuseIdentifier: reuseIdentifier)
                return newCell
            }
        }
        return nil;
    }

    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionInfo = sectionDataDic[kSection(section)]
        let viewInfo = (sectionInfo?.headViewInfo)! as SQTableViewHeadViewInfo
        
        var cell = tableView.dequeueReusableCellWithIdentifier(viewInfo.cellNibName.isEmpty ? viewInfo.cellNibName : viewInfo.cellClassName)
        if nil == cell {
            cell = cellForSection(viewInfo, tableView: tableView)
        }
        
        (cell as! SQTableViewBaseCell).fillData(viewInfo)
        return cell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionInfo = sectionDataDic[kSection(section)]
        let viewInfo = (sectionInfo?.footViewInfo)! as SQTableViewFootViewInfo
        
        var cell = tableView.dequeueReusableCellWithIdentifier(viewInfo.cellNibName.isEmpty ? viewInfo.cellNibName : viewInfo.cellClassName)
        if nil == cell {
            cell = cellForSection(viewInfo, tableView: tableView)
        }
        
        (cell as! SQTableViewBaseCell).fillData(viewInfo)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionInfo = sectionDataDic[kSection(section)]
        let viewInfo = (sectionInfo?.footViewInfo)! as SQTableViewFootViewInfo
        return viewInfo.cellHeight
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let sectionInfo = sectionDataDic[kSection(indexPath.section)]
            
            let cellInfo = sectionInfo!.cellDataArray[indexPath.row] as! SQTableViewBaseInfo;
            if nil != cellInfo.willDeleteBlock {
                cellInfo.willDeleteBlock!(args: cellInfo)
            }
            sectionInfo?.cellDataArray.removeObject(cellInfo)
            tableView.reloadData()        
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return canEdit
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sectionInfo = sectionDataDic[kSection(indexPath.section)]
        
        let cellInfo = sectionInfo!.cellDataArray[indexPath.row] as! SQTableViewBaseInfo;

        if nil != cellInfo.gotoNextBlock {
            cellInfo.gotoNextBlock!(args: cellInfo)
        }
    }
    
}


class SQTableViewSectionInfo: NSObject {
    var headViewInfo = SQTableViewHeadViewInfo()
    var footViewInfo = SQTableViewFootViewInfo()
    
    var cellDataArray = NSMutableArray()
}

class SQTableViewBaseInfo : NSObject {
    var cellNibName = String()
    var cellClassName = String()
    var cellStyle = UITableViewCellStyle.Default
    var indexPath = NSIndexPath()
    ///  这是一个函数闭包变量
    typealias  myfunction = (args:AnyObject) ->Void;
    //  定义函数变量
    var gotoNextBlock = myfunction?()
    var willDeleteBlock = myfunction?()
    
    var cellWidth:CGFloat = 0.0;
    var cellHeight:CGFloat = 0.0;
}

class SQTableViewHeadViewInfo : SQTableViewBaseInfo {

}

class SQTableViewFootViewInfo : SQTableViewBaseInfo {

}

class SQTableViewCellInfo : SQTableViewBaseInfo{

}

//@objc(SQCollectionViewBaseCell)
//@objc
class SQTableViewBaseCell: UITableViewCell {

    func fillData(info:SQTableViewBaseInfo) -> Void {

    }
}
