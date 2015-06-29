//
//  ViewController.swift
//  Uitest
//
//  Created by brzhang on 15/6/12.
//  Copyright (c) 2015年 brzhang. All rights reserved.
//

import UIKit


class ViewController: UIViewController{
    
    @IBOutlet weak var noteTableView: UITableView!
    var noteList  = [Note]()
    var noteManger:NoteDbManger?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noteTableView.dataSource = self
        self.noteTableView.delegate = self
        self.noteTableView.reloadData()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain,target: nil, action: nil)
        self.noteTableView.estimatedRowHeight = 80
        self.noteTableView.rowHeight = UITableViewAutomaticDimension
        // init noteMnager
        noteManger = NoteDbManger()
        reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        reloadData()
        navigationController?.hidesBarsOnSwipe = true
    }
    
    /**
    重新load数据
    */
    private func reloadData(){
        if let _noteList = noteManger?.listNotes(){
            self.noteList = _noteList
            self.noteTableView.reloadData()
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  let identifierSegu = segue.identifier{
            var viewController = segue.destinationViewController as! NoteDetailViewController
            switch identifierSegu{
            case "creatNewNoteSegues":
                 break
                
            case "DetailNoteSegues":
                if let rowSelect = self.noteTableView.indexPathForSelectedRow()?.row{
                    viewController.note = self.noteList[rowSelect]
                }
            default:
                break
            }
        }
    }
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
    }

}

extension ViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.noteList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var noteTableCell:NoteTableViewCell =  self.noteTableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! NoteTableViewCell
        var currentNote = self.noteList[indexPath.row]
        noteTableCell.noteTitle.text  = currentNote.noteTitle ?? "not tile"
        noteTableCell.noteAbstract.text = currentNote.noteAbstract ?? "no content"
        if let noteState = currentNote.noteState{
        
            switch (noteState){
            case -1,0:
                noteTableCell.noteImage.image = UIImage(named: "sad");
            case 1:
                noteTableCell.noteImage.image = UIImage(named: "sad");
            case 2:
                noteTableCell.noteImage.image = UIImage(named: "tongue");
            case 3:
                noteTableCell.noteImage.image = UIImage(named: "tongue");
            case 4:
                noteTableCell.noteImage.image = UIImage(named: "wink");
            case 5:
                noteTableCell.noteImage.image = UIImage(named: "wink");
            case 6:
                noteTableCell.noteImage.image = UIImage(named: "grin");
            case 7,8,9:
                noteTableCell.noteImage.image = UIImage(named: "grin");
            default:
                break;
            }
        }
        
        return noteTableCell
    }
}


extension ViewController:UITableViewDelegate
{
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let _note = self.noteList[indexPath.row]
        noteManger?.deleteNote(_note)
        reloadData()
    }

}
