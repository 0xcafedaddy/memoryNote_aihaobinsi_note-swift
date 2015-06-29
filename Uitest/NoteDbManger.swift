//
//  NoteDbManger.swift
//  Uitest
//    笔记数据库操作类
//
//  Created by brzhang on 15/6/26.
//  Copyright (c) 2015年 brzhang. All rights reserved.
//

import Foundation
import SQLite

class NoteDbManger{
    
    var db :Database
    var notes:Query
    var notesNotifications:Query
    
    let id: Expression<Int64>
    let noteTitle : Expression<String>
    let noteContent: Expression<String?>
    let noteAbstract:Expression<String?>
    let noteCtime: Expression<Int64?>
    let noteMtime:Expression<Int64?>
    
    let noteId:Expression<Int64>
    let noteState:Expression<Int>
    
    init(){
        var path = FileUtils.getCurrentUserPath()
        self.db = Database("\(path)/dbnotes.sqlite3")
        self.notes = db["note_table"]
        self.notesNotifications = db["note_notification_table"]
        self.id = Expression<Int64>("id")
        self.noteTitle = Expression<String>("noteTitle")
        self.noteContent = Expression<String?>("noteContent")
        self.noteAbstract = Expression<String?>("noteAbstract")
        self.noteCtime = Expression<Int64?>("noteCtime")
        self.noteMtime = Expression<Int64?>("noteMtime")
        //建表，自动检测表是否存在
        self.noteId = Expression<Int64>("noteId")
        self.noteState = Expression<Int>("currentNoticieIndex")//当前note已经提醒到了哪里
        createtable()
    }
    
    private func createtable(){
        // CREATE TABLE "users" (
        //     "id" INTEGER PRIMARY KEY NOT NULL,
        //     "name" TEXT,
        //     "email" TEXT NOT NULL UNIQUE
        // )
        
        db.create(table: self.notes,ifNotExists:true) { t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(noteTitle)
            t.column(noteAbstract)
            t.column(noteContent)
            t.column(noteCtime)
            t.column(noteMtime)
        }
        
    }
    
    func listNotes() ->[Note]{
        // SELECT * FROM "users"
        
        var noteList = [Note]()
        var alice = self.notes.select(notes[id],noteTitle,noteAbstract,noteContent,noteContent,noteCtime,noteMtime,noteState).join(self.notesNotifications, on: notes[id] == notesNotifications[noteId])
        for _note in alice{
            var note = Note()
            note.id = _note[id]
            note.noteTitle = _note[noteTitle]
            note.noteAbstract = _note[noteAbstract]
            note.noteContent = _note[noteContent]
            note.noteCtime = _note[noteCtime]
            note.noteMtime = _note.get(noteMtime)
            note.noteState = _note.get(noteState)
            noteList.append(note)
        }
        return noteList
    }
    
    // INSERT INTO "notes" ("noteTitle", "noteAbstract","noteContent","noteCtime","noteMtime") VALUES (....)
    func insertNote(note:Note)->Int64{
        var alice: Query?
        if note.noteTitle != nil{
            if let rowid = self.notes.insert(noteTitle <- note.noteTitle!,noteContent <- note.noteContent,noteAbstract <- note.noteAbstract,noteCtime <- note.noteCtime,noteMtime <- note.noteMtime).rowid {
                println("inserted id: \(rowid)")
                return rowid
            }else{
                return 0
            }
        }else{
            return 0
        }
        
    }
    
    //query select * from table where  
    func queryNote(_noteId:Int64)->Note?{
        var alice = notes.select(notes[id],noteTitle,noteAbstract,noteContent,noteContent,noteCtime,noteMtime,noteState).filter(self.id == _noteId).join(self.notesNotifications, on: self.id == notesNotifications[noteId])
        if let _note  = alice.first{
            var note = Note()
            note.id = _note[self.id]
            note.noteTitle = _note.get(noteTitle)
            note.noteContent = _note.get(noteContent)
            note.noteAbstract = _note.get(noteAbstract)
            note.noteCtime = _note.get(noteCtime)
            note.noteMtime = _note.get(noteMtime)
            note.noteState = _note.get(noteState)
            return note
        }else{
            return nil
        }
        
    }
    
    
    // UPDATE "users" SET "email" = ''' where id ='''
    func updateNote(note:Note){
        var alice: Query?
        if note.noteTitle != nil  && note.id != nil{
            alice = notes.filter(id == note.id!)
            let update  = alice?.update(noteTitle <- note.noteTitle!,noteContent <- note.noteContent,noteAbstract <- note.noteAbstract,noteMtime <- 11234132)
            if let changes = update!.changes where changes > 0 {
                println("updated successfull!")
            } else if update!.statement.failed {
                println("update failed: \(update!.statement.reason)")
            }
        }
    }
    // delete from  table where   ...
    func deleteNote(note:Note){
        var alice: Query?
        if note.id != nil{
            alice = notes.filter(id == note.id!)
            let update  =  alice?.delete()
            if let changes = update!.changes where changes > 0{
                println("delete successfully")
            }else if update!.statement.failed{
                println("delete failed \(update!.statement.reason)")
            }
        }
        
    }
    
    // SELECT count(*) FROM "users"
    func countUser()->Int{
        return notes.count
        
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

