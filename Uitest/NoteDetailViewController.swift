//
//  NoteDetailViewController.swift
//  Uitest
//
//  Created by brzhang on 15/6/23.
//  Copyright (c) 2015年 brzhang. All rights reserved.
//

import UIKit
import RichEditorView

class NoteDetailViewController: UIViewController {
    
    
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteContent:RichEditorView!
    
    var noteId:Int64?
    
    var note:Note?
    
    var noteNotification:NoteNotification?
    
    //is editing note
    var isEditingNote = false
    
    /// rich text block
    var toolbar: RichEditorToolbar { return self.keyboardManager.toolbar }
    
    lazy var keyboardManager: KeyboardManager = { KeyboardManager(view: self.view) }()
    
    /// 摘要生成器
    let summary = Summary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化 富文本编辑器
        initRichTextView()
        if let _noteId = noteId{
            //说明通过提醒近来
            note = NoteDbManger().queryNote(_noteId)
            noteNotification  =  NoteNotificationDbManger().queryNotification(note!)
            noteNotification?.currentNoticieIndex!++
            NoteNotificationDbManger().updateNoteNotifaction(noteNotification!)
            
        }
        if let _note = note{
            self.title = "编辑笔记"
            showNoteDetail(_note)
            if(noteNotification == nil){
                noteNotification  =  NoteNotificationDbManger().queryNotification(_note)
            }
            self.isEditingNote = true
        }else{
            self.title = "新建笔记"
            self.isEditingNote = false
        }
    
    }
    
    private func showNoteDetail(note:Note?){
        if let _note = note{
            noteTitle.text = _note.noteTitle
            noteContent.setHTML(_note.noteContent!)
        }
    }
    /**
    初始化富文本编辑器
    
    :returns: void
    */
    private func initRichTextView(){
        // We will create a custom action that clears all the input text when it is pressed
        keyboardManager.toolbar.editor = self.noteContent
    
        noteContent.delegate = self
        
        toolbar.delegate = self
        
        // We will create a custom action that clears all the input text when it is pressed
        let item = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
            toolbar?.editor?.setHTML("")
        }
        let deleteItem = RichEditorOptionItem(image:nil,title:"⬇︎"){toolbar in
            toolbar?.editor?.blur()
        }
        var options = toolbar.options
        options.append(item)
        options.insert(deleteItem, atIndex: 0)
        toolbar.options = options
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        keyboardManager.beginMonitoring()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardManager.stopMonitoring()
    }

    @IBAction func saveNote(sender: AnyObject) {
        if isEditingNote{ // editing existing note
            note?.noteTitle = self.noteTitle.text
            note?.noteContent = self.noteContent.getHTML()
            note?.noteAbstract = summary.getSummary(self.noteTitle.text, content: self.noteContent.getText())
            note?.noteMtime = TimeUtils.getCurrentTimeStamp()
            NoteDbManger().updateNote(note!)
            NoteNotificationDbManger().updateNoteNotifaction(noteNotification!)
            
        }else { // add new note
            
            if noteNotification == nil{
                var alertView  =  UIAlertView(title: "注意", message: "请点左下角添加提醒周期", delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
                return
            }
            
            note = Note()
            note?.noteTitle = self.noteTitle.text
            note?.noteContent = self.noteContent.getHTML()
            note?.noteAbstract = summary.getSummary(self.noteTitle.text, content: self.noteContent.getText())
            note?.noteCtime = TimeUtils.getCurrentTimeStamp()
            note?.noteMtime = TimeUtils.getCurrentTimeStamp()
            var rowid = NoteDbManger().insertNote(note!)
            //将刚刚插入的note的id拿到，给notification关联
            noteNotification?.noteId = rowid
            //为note添加 提醒周期
            addNoteNotification(noteNotification);
        }
        // Execute the unwind segue and go back to the home screen
        performSegueWithIdentifier("unwindToHomeScreen", sender: self)
    }
    
    func addNoteNotification(notification:NoteNotification?){
        if var _nofitification = notification {
            NoteNotificationDbManger().insertNoteNotification(_nofitification)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier{
            switch identifier {
            
                case "setNotificationList":
                var vc = segue.destinationViewController as! NoteNotificationTableViewController
                vc.noteNotification = self.noteNotification
            default:
                break
            }
        }
    }


}

// MARK: RichEditorDelegate

extension NoteDetailViewController: RichEditorDelegate {
    
    func richEditor(editor: RichEditorView, heightDidChange height: Int) { }
    
    func richEditor(editor: RichEditorView, contentDidChange content: String) {
        if content.isEmpty {
            print("html view")
        } else {
            println(content)
        }
    }
    
    func richEditorTookFocus(editor: RichEditorView) { }
    
    func richEditorLostFocus(editor: RichEditorView) { }
    
    func richEditorDidLoad(editor: RichEditorView) { }
    
    func richEditorShouldInteractWithURL(url: NSURL) -> Bool { return false }
}

// MARK: UIImagePickerControllerDelegate

extension NoteDetailViewController:UIImagePickerControllerDelegate
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        //        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        //        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        //        imageView.clipsToBounds = true
        
        var originalImage =  info[UIImagePickerControllerOriginalImage] as? UIImage
        var scaledImage:UIImage?
        if originalImage?.imageOrientation == .Right{
           originalImage = originalImage?.fixOrientation()
        }
        var imageData  = UIImagePNGRepresentation(originalImage)
        var scalingFactor = (originalImage!.size.width > 1024) ? (1024.0 / originalImage!.size.width) : 1.0
        scaledImage =  UIImage(data: imageData, scale: scalingFactor)
        // Write the image to local file for temporary use
        let imageFilePath  =  NSTemporaryDirectory() + "\(NSDate().timeIntervalSince1970)"
        UIImageJPEGRepresentation(scaledImage, 0.8).writeToFile(imageFilePath, atomically: true)
        self.toolbar.editor?.insertImage(imageFilePath,width:self.noteContent.bounds.width,height:self.noteContent.bounds.height, alt: "do not delete this photo")
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}

extension NoteDetailViewController:UINavigationControllerDelegate
{
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
    }
}

// MARK: RichEditorToolbarDelegate
extension NoteDetailViewController: RichEditorToolbarDelegate
{
    
    private func randomColor() -> UIColor {
        let colors = [
            UIColor.redColor(),
            UIColor.orangeColor(),
            UIColor.yellowColor(),
            UIColor.greenColor(),
            UIColor.blueColor(),
            UIColor.purpleColor()
        ]
        
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }
    
    func richEditorToolbarChangeTextColor(toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextColor(color)
    }
    
    func richEditorToolbarChangeBackgroundColor(toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextBackgroundColor(color)
    }
    
    func richEditorToolbarInsertImage(toolbar: RichEditorToolbar) {
        
        insertPicIntent()
    }
    
    func richEditorToolbarChangeInsertLink(toolbar: RichEditorToolbar) {
        toolbar.editor?.insertLink("http://github.com/bravekingzhang/", title: "Github Link")
    }
    
  
    /**
    拍照被点击
    todo 用alertview来让用户选择是否使用相册中得图片
    
    :param: sender <#sender description#>
    */
    @IBAction func takePhotoButtonPressed(sender: AnyObject) {
        insertPicIntent()
    }
    
    private func insertPicIntent(){
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }else if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            imagePicker.sourceType = .PhotoLibrary
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindNoteDetailScreen(segue:UIStoryboardSegue) {
        //将设置的通知传递回来。
        if let vc =  segue.sourceViewController as? NoteNotificationTableViewController{
            self.noteNotification =  vc.noteNotification
        }
        
    }
    
//    @IBAction func updateNoteNotification(sender: AnyObject) {
//        if isEditingNote{ // editing existing note
//        }else { // add new note
//            
//            note = Note()
//            note?.noteTitle = self.noteTitle.text
//            note?.noteContent = self.noteContent.getHTML()
//            note?.noteAbstract = summary.getSummary(self.noteTitle.text, content: self.noteContent.getText())
//            noteManger?.updateNote(note!)
//        }
//        // Execute the unwind segue and go back to the home screen
//        performSegueWithIdentifier("unwindToHomeScreen", sender: self)
//    }
    
}



