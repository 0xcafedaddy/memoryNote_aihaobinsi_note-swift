//
//  NoteNotificationDbManger.swift
//  Uitest
//  笔记相关提醒类
//  Created by brzhang on 15/6/26.
//  Copyright (c) 2015年 brzhang. All rights reserved.
//

import Foundation
import SQLite

class NoteNotificationDbManger{
    
    var db :Database
    var noteNotifications:Query
    let maxIndexOfcurrent = 6
    let minIndexOfCurrent = 1
    
    let id: Expression<Int64>
    let noteId : Expression<Int64>
    let first: Expression<Int64>
    let second:Expression<Int64>
    let third:Expression<Int64>
    let forth:Expression<Int64>
    let fifth:Expression<Int64>
    let six:Expression<Int64>
    let currentNoticieIndex:Expression<Int>
    
    init(){
        var path = FileUtils.getCurrentUserPath()
        self.db = Database("\(path)/dbnotes.sqlite3")
        self.noteNotifications = db["note_notification_table"]
        self.id = Expression<Int64>("id")
        self.noteId = Expression<Int64>("noteId")
        self.first = Expression<Int64>("first")
        self.second = Expression<Int64>("second")
        self.third = Expression<Int64>("third")
        self.forth = Expression<Int64>("forth")
        self.fifth = Expression<Int64>("fifth")
        self.six = Expression<Int64>("six")
        self.currentNoticieIndex = Expression<Int>("currentNoticieIndex")
        
        //建表，自动检测表是否存在
        createTable()
    }
    
    private func createTable(){
     
        db.create(table: self.noteNotifications,ifNotExists:true) { t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(noteId)
            t.column(first)
            t.column(second)
            t.column(third)
            t.column(forth)
            t.column(fifth)
            t.column(six)
            t.column(currentNoticieIndex)
        }
        
    }
    
    /**
    更新数据库时可以用到这个 。
    */
    private func updateTable(){
    
        db.alter(table: self.noteNotifications, add: self.six, defaultValue: 0)
    }
    
    func queryNotification(note:Note) ->NoteNotification?{
        var query = self.noteNotifications.filter(noteId == note.id!)
        if let _notification = query.first{
            var noteNotification = NoteNotification()
            noteNotification.id =  _notification.get(id)
            noteNotification.noteId = _notification.get(noteId)
            noteNotification.first = _notification.get(first)
            noteNotification.second = _notification.get(second)
            noteNotification.third = _notification.get(third)
            noteNotification.forth = _notification.get(forth)
            noteNotification.fifth = _notification.get(fifth)
            noteNotification.six = _notification.get(six)
            noteNotification.currentNoticieIndex = _notification.get(currentNoticieIndex)
            return noteNotification
        }else{
            return nil
        }
    }
    
    func listShouldNotify()->[NoteNotification]{
    
        var notificationList = [NoteNotification]()
        var currentTimeStamp = TimeUtils.getCurrentTimeStamp()
        var query = self.noteNotifications.filter(currentNoticieIndex <= 6)
        for notification in query{
            var oneNotification = NoteNotification()
            oneNotification.id =  notification.get(id)
            oneNotification.noteId = notification.get(noteId)
            oneNotification.first = notification.get(first)
            oneNotification.second = notification.get(second)
            oneNotification.third = notification.get(third)
            oneNotification.forth = notification.get(forth)
            oneNotification.fifth = notification.get(fifth)
            oneNotification.six = notification.get(six)
            oneNotification.currentNoticieIndex = notification.get(currentNoticieIndex)
            
            if let _currentIndexOfNotification = oneNotification.currentNoticieIndex{
                switch  _currentIndexOfNotification{
                case 1:
                    if oneNotification.first > currentTimeStamp{
                        notificationList.append(oneNotification)
                    }
                case 2:
                    if oneNotification.second > currentTimeStamp{
                        notificationList.append(oneNotification)
                    }
                case 3:
                    if oneNotification.third > currentTimeStamp{
                        notificationList.append(oneNotification)
                    }
                case 4:
                    if oneNotification.forth < currentTimeStamp{
                        notificationList.append(oneNotification)
                    }
                case 5:
                    if oneNotification.fifth < currentTimeStamp{
                        notificationList.append(oneNotification)
                    }
                case 6:
                    if oneNotification.six < currentTimeStamp{
                        notificationList.append(oneNotification)
                    }
                default:
                    break
                }

            }
            
        }
        return notificationList

    }
    
    func insertNoteNotification(notification:NoteNotification){
        var alice: Query?
        
        if let rowid = self.noteNotifications.insert(noteId <- notification.noteId!,first <- notification.first!,second <- notification.second!,third <- notification.third!,forth <- notification.forth!,fifth <- notification.fifth!,six <- notification.six!,currentNoticieIndex <- notification.currentNoticieIndex!).rowid {
            println("inserted id: \(rowid)")
        }
        
        
    }

    func updateNoteNotifaction(notification:NoteNotification){
        var alice: Query?
        alice = self.noteNotifications.filter(id == notification.id!)
        let update  = alice?.update(noteId <- notification.noteId!,first <- notification.first!,second <- notification.second!,third <- notification.third!,forth <- notification.forth!,fifth <- notification.fifth!,six <- notification.six!,currentNoticieIndex <- notification.currentNoticieIndex!)
        if let changes = update!.changes where changes > 0 {
            println("updated successfull!")
        } else if update!.statement.failed {
            println("update failed: \(update!.statement.reason)")
        }
        
    }

    func deleteNoteNotifaction(id:Int64){
        var alice: Query?
        alice = self.noteNotifications.filter(self.id == id)
        let update  =  alice?.delete()
        if let changes = update!.changes where changes > 0{
            println("delete successfully")
        }else if update!.statement.failed{
            println("delete failed \(update!.statement.reason)")
        }
    }
    
    // SELECT count(*) FROM "users"
    func countNotification()->Int{
        return self.noteNotifications.count
        
    }
    
    func rawQuery(state:String?){
        if state != nil{
            let stmt = db.prepare(state!)
            let result  = stmt.run()
            if result.failed{
                println("query failed and reason is \(result.reason)")
            }
        }
    }

}

