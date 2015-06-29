//
//  NoteNotificationTableViewController.swift
//  Uitest
//
//  Created by brzhang on 15/6/25.
//  Copyright (c) 2015年 brzhang. All rights reserved.
//

import UIKit

class NoteNotificationTableViewController: UITableViewController {
    
    var isEditingNote = false
    
    var timeDatas = [Int64](count:6, repeatedValue: 0)
    var indexArray = [0:"一",1:"二",2:"三",3:"四",4:"五",5:"六"]
    var noteNotification:NoteNotification?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeDatas = [Int64](count:6, repeatedValue: 0)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if let  _notificatoin = noteNotification{
            timeDatas[0] = _notificatoin.first!
            timeDatas[1] = _notificatoin.second!
            timeDatas[2] = _notificatoin.third!
            timeDatas[3] = _notificatoin.forth!
            timeDatas[4] = _notificatoin.fifth!
            timeDatas[5] = _notificatoin.six!
        }else{
            //初始化为标准的艾宾浩斯提醒
            //最佳复习时段：第1天、第2天、第5天、第9天、第17天、第31天，复习周期为1个月。
            timeDatas[0] = Int64(NSDate().timeIntervalSince1970 + 24 * 3600)
            timeDatas[1] = Int64(NSDate().timeIntervalSince1970 + 2 * 24 * 3600)
            timeDatas[2] = Int64(NSDate().timeIntervalSince1970 + 5 * 24 * 3600)
            timeDatas[3] = Int64(NSDate().timeIntervalSince1970 + 9 * 24 * 3600)
            timeDatas[4] = Int64(NSDate().timeIntervalSince1970 + 17 * 24 * 3600)
            timeDatas[5] = Int64(NSDate().timeIntervalSince1970 + 31 * 24 * 3600)
            
            noteNotification = NoteNotification()
            noteNotification?.first = timeDatas[0]
            noteNotification?.second = timeDatas[1]
            noteNotification?.third = timeDatas[2]
            noteNotification?.forth = timeDatas[3]
            noteNotification?.fifth = timeDatas[4]
            noteNotification?.six = timeDatas[5]
            noteNotification?.currentNoticieIndex = 1//第一个记忆阶段没被触发
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return timeDatas.count
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var tableCell =  tableView.dequeueReusableCellWithIdentifier("notificationCell", forIndexPath: indexPath) as! NoteNotificationTableViewCell
        tableCell.notificationTimeData.text = TimeUtils.timeInterval(timeDatas[indexPath.row])
        tableCell.notificationTimeTitle.text = getTimeHeader(indexPath.row)
        return tableCell
    }
    
    private func getTimeHeader(index:Int)->String{
        return "第\(indexArray[index]!)次提醒"
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier{
            switch identifier{
            case "setNotificationTime":
                var vc = segue.destinationViewController as! TimeSettingViewController
                var selectRow = self.tableView.indexPathForSelectedRow()?.row
                vc.timeStamp = timeDatas[selectRow!]
            default:
                break
            }
            
        }
    }
    
    private func updateNoteNotification(timeDatas:[Int64]){
        self.noteNotification?.first = timeDatas[0]
        self.noteNotification?.second = timeDatas[1]
        self.noteNotification?.third = timeDatas[2]
        self.noteNotification?.forth = timeDatas[3]
        self.noteNotification?.fifth = timeDatas[4]
        self.noteNotification?.six = timeDatas[5]
    }
    
    @IBAction func updateNoteNotification(sender: AnyObject) {
        // Execute the unwind segue and go back to the home screen
        performSegueWithIdentifier("unwindNoteDetailScreen", sender: self)
    }
    
    
    @IBAction func unwindNotficationSettingScreen(segue:UIStoryboardSegue) {
        var timeSettingView =  segue.sourceViewController as! TimeSettingViewController
        if let timeStamp = timeSettingView.timeStamp{//拿到设置的时间
            var selectRow =  self.tableView.indexPathForSelectedRow()?.row
            timeDatas[selectRow!] = timeStamp
            //更新提醒周期
            updateNoteNotification(timeDatas)
            self.tableView.reloadData()
        }
    }
}
