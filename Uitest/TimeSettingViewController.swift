//
//  TimeSettingViewController.swift
//  Uitest
//
//  Created by brzhang on 15/6/25.
//  Copyright (c) 2015年 brzhang. All rights reserved.
//

import UIKit

class TimeSettingViewController: UIViewController {
    
    @IBOutlet weak var timeSelecter: UIDatePicker!
    var isEditingNote = false
    var timeStamp:Int64?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let _timeStamp = timeStamp{
            timeSelecter.setDate(NSDate(timeIntervalSince1970: Double(_timeStamp)), animated: true)

        }
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func updateOneNoteNotificationTime(sender: AnyObject) {
        // change timestamp
        timeStamp = Int64(timeSelecter.date.timeIntervalSince1970)
        // Execute the unwind segue and go back to the home screen
        performSegueWithIdentifier("unwindNotficationSettingScreen", sender: self)
    }
}
