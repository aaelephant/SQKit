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
    
    func loadData(_ originData:NSMutableDictionary) -> Void {
        sectionDataDic = originData
    }
    
    func kSection(_ section:NSInteger) -> NSString {
        return NSString(format: "%ld", section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (sectionDataDic.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = sectionDataDic[kSection(section)]
        return ((sectionInfo as AnyObject).cellDataArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionInfo = sectionDataDic[kSection(indexPath.section)]
        
        let cellInfo = (sectionInfo! as AnyObject).cellDataArray[indexPath.row] as! SQTableViewBaseInfo;
        cellInfo.indexPath = indexPath
        var cell = tableView.dequeueReusableCell(withIdentifier: cellInfo.cellNibName.isEmpty ? cellInfo.cellNibName : cellInfo.cellClassName);
        if (nil == cell) {
            cell = cellForSection(cellInfo , tableView: tableView)
        }
        (cell as! SQTableViewBaseCell).fillData(cellInfo );
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionInfo = sectionDataDic[kSection(indexPath.section)]
        
        let cellInfo = (sectionInfo! as AnyObject).cellDataArray[indexPath.row] as! SQTableViewBaseInfo;
        
        return cellInfo.cellHeight
    }
    
    func cellForSection(_ cellInfo:SQTableViewBaseInfo, tableView:UITableView) -> SQTableViewBaseCell {
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
    
    func loadNibCellWithNibName(_ nibName:String, tableView:UITableView, reuseIdentifier: String) -> SQTableViewBaseCell {
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! SQTableViewBaseCell
    }
    
    func swiftCellClassFromString(_ className: String, cellStyle:UITableViewCellStyle, reuseIdentifier: String) -> UITableViewCell! {
        // get the project name
        if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
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

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionInfo = sectionDataDic[kSection(section)]
        let viewInfo = ((sectionInfo as! SQTableViewSectionInfo).headViewInfo) as SQTableViewHeadViewInfo
        
        var cell = tableView.dequeueReusableCell(withIdentifier: viewInfo.cellNibName.isEmpty ? viewInfo.cellNibName : viewInfo.cellClassName)
        if nil == cell {
            cell = cellForSection(viewInfo, tableView: tableView)
        }
        
        (cell as! SQTableViewBaseCell).fillData(viewInfo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionInfo = sectionDataDic[kSection(section)]
        let viewInfo = ((sectionInfo as! SQTableViewSectionInfo).footViewInfo) as SQTableViewFootViewInfo
        
        var cell = tableView.dequeueReusableCell(withIdentifier: viewInfo.cellNibName.isEmpty ? viewInfo.cellNibName : viewInfo.cellClassName)
        if nil == cell {
            cell = cellForSection(viewInfo, tableView: tableView)
        }
        
        (cell as! SQTableViewBaseCell).fillData(viewInfo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionInfo = sectionDataDic[kSection(section)]
        let viewInfo = ((sectionInfo as! SQTableViewSectionInfo).footViewInfo) as SQTableViewFootViewInfo
        return viewInfo.cellHeight
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let sectionInfo = sectionDataDic[kSection(indexPath.section)]
            
            let cellInfo = (sectionInfo! as AnyObject).cellDataArray[indexPath.row] as! SQTableViewBaseInfo;
//            if cellInfo.willDeleteBlock {
                cellInfo.willDeleteBlock(cellInfo)
//            }
            (sectionInfo as AnyObject).cellDataArray.remove(cellInfo)
            tableView.reloadData()        
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return canEdit
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionInfo = sectionDataDic[kSection(indexPath.section)]
        
        let cellInfo = (sectionInfo! as AnyObject).cellDataArray[indexPath.row] as! SQTableViewBaseInfo;

//        if cellInfo.gotoNextBlock {
            cellInfo.gotoNextBlock(cellInfo)
//        }
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
    var cellStyle = UITableViewCellStyle.default
    var indexPath = IndexPath()
    ///  这是一个函数闭包变量
    typealias  myfunction = (_ args:AnyObject) ->Void;
    //  定义函数变量
    var gotoNextBlock:((_ args:AnyObject) -> Void) = { (args:AnyObject) in
        
    }

    var willDeleteBlock:((_ args:AnyObject) -> Void) = { (args:AnyObject) in
        
    }
//    var gotoNextBlock = (AnyObject) ->Void()//myfunction()
//    var willDeleteBlock = (AnyObject) ->Void()//myfunction()
    
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

    func fillData(_ info:SQTableViewBaseInfo) -> Void {

    }
}
