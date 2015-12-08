//
//  AppDelegate.swift
//  PDFViewer
//
//  Created by Matt Wynyard on 4/09/15.
//  Copyright (c) 2015 Niobium. All rights reserved.
//

import Foundation
import Quartz
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, PDFModelDelegate, NSOpenSavePanelDelegate {

    var model: PDFModel? = nil
    var notification = NSNotificationCenter.defaultCenter()
    var recentsAutosaveName: String = "history"
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var pdfView: PDFView!
    //menu items
    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var openFile: NSMenuItem!
    @IBOutlet weak var saveFile: NSMenuItem!
    @IBOutlet weak var prevPageMenu: NSMenuItem!
    @IBOutlet weak var nextPageMenu: NSMenuItem!
    @IBOutlet weak var zoomOutMenu: NSMenuItem!
    @IBOutlet weak var zoomInMenu: NSMenuItem!
    //toolbar
    @IBOutlet weak var pageCount: NSTextField!
    @IBOutlet weak var prevButton: NSButton! //previous document
    @IBOutlet weak var nextButton: NSButton! //next document
    @IBOutlet weak var prevPage: NSButton!
    @IBOutlet weak var nextPage: NSButton!
    @IBOutlet weak var pageNumber: NSTextField!
    @IBOutlet weak var zoomOutButton: NSButton!
    @IBOutlet weak var zoomInButton: NSButton!
    @IBOutlet weak var view: NSView!
    @IBOutlet weak var documentButton: NSPopUpButton!

    @IBOutlet weak var markCheck: NSButton!
    @IBOutlet weak var markTextField: NSTextField!
    @IBOutlet weak var searchField: NSSearchField!
    @IBOutlet weak var searchLabel: NSTextField!
    
    /**
    Initialising function that sets properties for the application. It is called when the 
    application received a notification
    it has finished launching.

    :param aNotification notfication reveived from the notification centre
    */
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        //A4 w = 210 h = 297
        let screenWidth = getScreenSize().width
        let screenHeight = getScreenSize().height
        //let pdfSize = NSSize(width: (screenHeight) * 0.75 , height: screenHeight * 0.75  - 100)
        //let windowSize = NSSize(width: screenHeight * 0.75, height: screenHeight * 0.75 - 50)
        let pdfSize = NSSize(width: 720 , height: 825)
        let windowSize = NSSize(width: 720, height: 875)
        let pdfOrigin = NSPoint(x: 0, y: 0)
        //window.setContentSize(windowSize)
        pdfView.setFrameSize(pdfSize)
        pdfView.setFrameOrigin(pdfOrigin)
        
        println("width = \(screenWidth) height = \(screenHeight)")

        model = PDFModel()
        model?.delegate = self
        model?.pdfArray  = NSMutableArray()
        validateDocumentButtons()
        
        //do set up
        //NSApp.mainMenu(set
        prevButton.enabled = false
        nextButton.enabled = false
        pageNumber.enabled = false
        searchField.enabled = false
        documentButton.enabled = false
        zoomInMenu.enabled = false
        zoomOutMenu.enabled = false
        nextPageMenu.enabled = false
        prevPageMenu.enabled = false
        
        markTextField.enabled = false
        
        documentButton.removeAllItems()
        pdfView.setAllowsDragging(true)
       
        window.minSize.width = 600

    }
    
    
    func getScreenSize() -> NSRect {
        return NSScreen.mainScreen()!.frame
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    /** checks whether current document is the first or last document
        and sets forward and back documents to be enabled or dis-abled
    */
    func validateDocumentButtons() {
        if model!.documentIndex <= 0 && model!.pdfArray.count <= 1 {
            prevButton.enabled = false //no document loaded
            nextButton.enabled = false
            
        } else if model!.documentIndex >= model!.pdfArray.count - 1 {
            prevButton.enabled = true
            nextButton.enabled = false
        } else if model!.documentIndex <= 0 {
            prevButton.enabled = false
            nextButton.enabled = true
        } else {
            prevButton.enabled = true
            nextButton.enabled = true
            
        }
    }
    
    /** checks whether current document is at the first or last page
    and sets forward and back documents to be enabled or dis-abled
    
    :param: page No the current page number in the document
    :param: direction whether last page change was forward > 0 or backward < 0
    */
    
    func validatePageButtons(page: PDFPage) {
        //println("buttons")
        let document = pdfView.document()
        let index = document.indexForPage(page)

        if index + 1 >= pageCount.stringValue.toInt()! { //reached end of document
            prevPage.enabled = true
            nextPage.enabled = false
            prevPageMenu.enabled = true
            nextPageMenu.enabled = false
        } else if index == 0 { //&& direction <= 0 { //new document or at start and prev pushed
            prevPage.enabled = false
            nextPage.enabled = true
            prevPageMenu.enabled = false
            nextPageMenu.enabled = true
        } else if pageCount.stringValue.toInt() == 1 {
            prevPage.enabled = false
            nextPage.enabled = false
            prevPageMenu.enabled = false
            nextPageMenu.enabled = false
        } else {
            prevPage.enabled = true
            nextPage.enabled = true
            prevPageMenu.enabled = true
            nextPageMenu.enabled = true
        }
    }
    
    /** called when the current page changes sends updated page
    to model

    :param: notfication received from NSNoftication centre
    **/
    func pageChangedNotification(notification: NSNotification) {
        let page: PDFPage = pdfView.currentPage()
        model?.updatePage(page)
    }
    
    /** called when new documents are open. Sets page changed notification
    and enables buttons and textfields on toolbar
    
    :param: document the PDF document being opened
    */
    func documentsFinishedLoading(document: PDFDocument) {
        notification.addObserver(self, selector: "pageChangedNotification:", name: PDFViewPageChangedNotification, object: pdfView)
        pageNumber.enabled = true
        searchField.enabled = true
        markTextField.enabled = true
        }
    
    /** displays the current pdf document in the PDF view, sets attributes and
    does button validation.
    
    :param: document the current PDF document being displayed
    :param: index the index of the document in the document array
    */
    func documentDidChange(document: PDFDocument, index: Int) {
        pdfView.setDocument(document)
         pdfView.setAutoScales(true)
        window.setTitleWithRepresentedFilename(document.documentURL().relativeString!)
        pageCount.stringValue = String(document.pageCount())
        validateDocumentButtons()
        validatePageButtons(document.pageAtIndex(0))
        documentButton.addItemsWithTitles(model?.titleArray as! [AnyObject])
        documentButton.selectItemAtIndex(index)
        syncMark(index)

    }
    
    /** gets the index of the current page and updates page textfield
    then sends current page to goToPage function
    
    :param: page the current page being displayed
    :param: direction whether user is navigating forward or backwards
    */
    func pageDidChange(page: PDFPage, direction: Int) {
        validatePageButtons(page)
        var document = pdfView.document()
        pageNumber.stringValue = String(document.indexForPage(page) + 1)
        pdfView.goToPage(page)
    }
    
    /** gets the mark from the current document and sets in textfield

    :param: index of the current document
    */
    func syncMark(index: Int) {
        let markBook: MarkBook = model?.refArray.objectAtIndex(index) as! MarkBook
        markTextField.stringValue = markBook.mark
    }
    
    @IBAction func changeDocument(sender: NSPopUpButton) {
        model?.updateDocument(sender.indexOfSelectedItem)
    }
    @IBAction func autoScale(sender: NSButton) {
         pdfView.setAutoScales(true)
    }
    
    @IBAction func autoScaleMenu(sender: NSMenuItem) {
        pdfView.setAutoScales(true)
    }
    @IBAction func prevPage(sender: NSButton) {
        model?.prevPage()
    }

    @IBAction func nextPage(sender: NSButton) {
        model?.nextPage()
    }

    @IBAction func nextPageKey(sender: NSMenuItem) {
        model?.nextPage()
    }
    
    @IBAction func previousPageKey(sender: NSMenuItem) {
        model?.prevPage()
    }
    
    @IBAction func goBackMenu(sender: NSMenuItem) {
        
        model?.goBack() 


    }
    @IBAction func aboutMenu(sender: AnyObject) {
        
        let alert: NSAlert = NSAlert()
        alert.messageText = "PDFMarkBook"
        alert.informativeText = "Version 1.0\u{000A}\u{000A}Application for viewing and marking multiple pdf documents.\u{000A}\u{000A}All image icons used in this application are believed to have been obtained from free sources. Icons have been created by freepik.com and have be downloaded from www.icons.iconarchive.com and flaticon.com.\u{000A}\u{000A}Created by Matt Wynyard. Copyright \u{00A9} 2015 Niobium All rights reserved."
        alert.runModal()
    }
    
    @IBAction func goForwardMenu(sender: NSMenuItem) {
        pdfView.goForward(sender)
        
        
    }
    
    @IBAction func zoomOutMenu(sender: NSMenuItem) {
        pdfView.zoomOut(self)
        
    }
    
    @IBAction func zoomInMenu(sender: NSMenuItem) {
        pdfView.zoomIn(self)
    }

    @IBAction func zoomIn(sender: NSButton) {
        pdfView.zoomIn(self)
    }

    
    @IBAction func zoomOut(sender: NSButton) {
        pdfView.zoomOut(self)
    }

    @IBAction func nextDocument(sender: NSButton) {
        model?.nextDocument()
    }
    
    @IBAction func prevDocument(sender: NSButton) {
        model?.prevDocument()
    }
    
    @IBAction func goToPage(sender: NSTextField) {
        model?.goToPage(pageNumber.stringValue)
        
    }
    
    @IBAction func markDocument(sender: NSTextField) {
        println(sender.stringValue.toInt())
        if sender.stringValue.toInt() < 0 || sender.stringValue.toInt() == nil {
            return
        }
        model?.updateMark(markTextField.stringValue)
    }

    @IBAction func search(sender: NSSearchField) {
        let document: PDFDocument = pdfView.document()
        var selectionMain: PDFSelection = PDFSelection(document: document)
        let searchValue: String = searchField.stringValue.lowercaseString
        let searchString: String = pdfView.document().string().lowercaseString
        let words = split(searchString) {$0 == " "}
        let filterArray = words.filter {$0 == searchValue}
        let resultArray: NSMutableArray = []
        if searchValue != "" {
            searchLabel.stringValue = "Found \(filterArray.count) occurrences"
        } else {
            searchLabel.stringValue = ""
        }
        if !document.isFinding() && searchValue != "" {
            for var i = 0; i < filterArray.count; i++ {
                var result: PDFSelection! = document.findString(searchValue, fromSelection: selectionMain, withOptions: 0)
                selectionMain = result
                if let r = result {
                   resultArray.addObject(r)
                }
            }
            if resultArray.count > 0 {
                selectionMain.addSelections(resultArray as [AnyObject])
                selectionMain.setColor(NSColor.yellowColor())
                pdfView.setCurrentSelection(selectionMain)
                pdfView.scrollSelectionToVisible(self)
            }
        } else {
            pdfView.setCurrentSelection(nil)
        }

    }
    @IBAction func saveFile(sender: NSMenuItem) {
        model?.writeFile()
    }
    
    func openPBMFile(path: String!) -> String {
        let file = "PDFMarkBook.pbm"
        if let dirs: [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
            let dir = dirs[0] //document directory
            let path = dir.stringByAppendingPathComponent(file)
        }
        let contents = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
        return contents!
    }

    @IBAction func openFile(sender: NSMenuItem) {
        let panel: NSOpenPanel = NSOpenPanel()
        var pathArray: NSMutableArray = []
        var marks: NSMutableArray = []
        var paths = []
        var fileType = ""
        panel.canChooseFiles = true
        panel.allowedFileTypes = ["pdf", "pmb"]
        panel.allowsMultipleSelection = true
        documentButton.enabled = true
        panel.beginSheetModalForWindow(self.window) { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
                if panel.URL!.pathExtension! == "pmb" {
                    var path = panel.URL!
                    let file: String = path.filePathURL!.path!
                    self.openPBMFile(file)
                    var files = self.openPBMFile(file)
                    let fileArray = split(files) {$0 == "\n"} as NSArray
                    for var i = 0; i < fileArray.count; i++ {
                        if i % 2 != 0 {
                            marks.addObject(fileArray.objectAtIndex(i))
                        } else {
                            let url = NSURL(string: fileArray.objectAtIndex(i) as! String)!
                            pathArray.addObject(fileArray.objectAtIndex(i))
                        }
                    }
                    paths = pathArray as NSArray
                    fileType = "pmb"
                } else { //opening pdf document
                    paths = pathArray as NSArray
                    paths = panel.URLs
                    fileType = "pdf"
                }
                if fileType == "pdf" {
                    for path in paths {
                        //println(path)
                        if let p: NSURL = path as? NSURL {
                            let file: String = p.filePathURL?.pathComponents!.last! as! String!
                            let pdf = PDFDocument(URL: p)
                            self.model?.refArray.addObject(MarkBook(url: p, mark: "?"))
                            //println(p)
                            self.model?.pdfArray.addObject(pdf)
                            self.model?.titleArray.addObject(file)
                        }
                    }
                } else {
                    for var i = 0; i < paths.count; i++ {
                        let p = NSURL(string: paths.objectAtIndex(i) as! String)!
                        let file: String = p.filePathURL?.pathComponents!.last! as! String!
                        let pdf = PDFDocument(URL: p)
                        self.model?.refArray.addObject(MarkBook(url: p, mark: marks.objectAtIndex(i) as! String))
                        self.model?.pdfArray.addObject(pdf)
                        self.model?.titleArray.addObject(file)
                        self.syncMark(i)
                    }
                } //end if
                self.model?.loadDocuments(paths.count)
            } //end menu if
        } // end closure
    } // end func
} // end class

