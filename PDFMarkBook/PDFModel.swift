//
//  PDFModel.swift
//  PDFViewer
//
//  Created by Matt Wynyard on 9/09/15.
//  Copyright (c) 2015 Niobium. All rights reserved.
//

import Quartz

public protocol PDFModelDelegate {
    
    func documentsFinishedLoading(document: PDFDocument)
    func documentDidChange(document: PDFDocument, index: Int)
    func pageDidChange(page: PDFPage, direction: Int)
}

class PDFModel: NSObject {
    
    var pdfArray: NSMutableArray! //array of PDF documents
    var titleArray: NSMutableArray = [] //array of file names
    var refArray: NSMutableArray = [] //contains MarkBook objects
    var pageHistory: NSMutableArray = [] //not used
    var documentIndex: Int = 0 //current document being viewed
    var pageIndex: Int? = nil
    var currentPage: PDFPage? = nil
    var previousPage: PDFPage? = nil
    var delegate:PDFModelDelegate? = nil
    var currentDocument: PDFDocument?
    var destination: PDFDestination? = nil
    
    /** adds documents being opened to the pdfArray and initialises document index

    :param: count the number of documents being opened
    */
    func loadDocuments(count: Int) {
        if count == 1 {
            currentDocument = pdfArray.objectAtIndex(pdfArray.count - 1) as? PDFDocument
            documentIndex = pdfArray.count - 1
        } else {
            currentDocument = pdfArray.objectAtIndex(0) as? PDFDocument
            documentIndex = 0
        }
        currentPage = currentDocument?.pageAtIndex(0)
        pageIndex = 0
        delegate?.documentDidChange(currentDocument!, index: documentIndex)
        delegate?.pageDidChange(currentPage!, direction: 0)
        delegate?.documentsFinishedLoading(currentDocument!)
    }
    
    /** navigates to next document and sends current document and index and
    current page and direction (direction zero as page not being changed to controller
    */
    func nextDocument() {
        currentDocument = pdfArray.objectAtIndex(++documentIndex) as? PDFDocument
        currentPage = currentDocument?.pageAtIndex(0)
        pageIndex = 0
        delegate?.documentDidChange(currentDocument!, index: documentIndex)
        delegate?.pageDidChange(currentPage!, direction: 0)
    }
    
    /** navigates to previous document and sends current document and index and
    current page and direction (direction zero as page not being changed to controller
    */
    func prevDocument() {
        currentDocument = pdfArray.objectAtIndex(--documentIndex) as? PDFDocument
        currentPage = currentDocument?.pageAtIndex(0)
        pageIndex = 0
        delegate?.documentDidChange(currentDocument!, index: documentIndex)
        delegate?.pageDidChange(currentPage!, direction: 0)
    }
    
    /** navigates to next page by sending current page to controller and direction 1 as
    page is being moved forward. also updates current page index
    */
    func nextPage() {
        pageIndex = currentDocument?.indexForPage(currentPage)
        pageHistory.addObject(currentPage!)
        previousPage = currentPage
        currentPage = currentDocument?.pageAtIndex(++pageIndex!)
        delegate?.pageDidChange(currentPage!, direction: 1)
    }
    
    /** navigates to previous page by sending current page to controller and direction -1 as
    page is being moved back. Also updates current page index
    */
    func prevPage() {
        pageIndex = currentDocument?.indexForPage(currentPage)
        pageHistory.addObject(currentPage!)
        previousPage = currentPage
        currentPage = currentDocument?.pageAtIndex(--pageIndex!)
        delegate?.pageDidChange(currentPage!, direction: -1)
    }
    
    
    /** not used 
    */
    func goBack() {
    }
    
    /** updates the current document in the pdfArray sends current document to controller

    :param: index of current document
    */
    func updateDocument(index: Int) {
        currentDocument = pdfArray.objectAtIndex(index) as? PDFDocument
        currentPage = currentDocument?.pageAtIndex(0)
        documentIndex = index
        delegate?.documentDidChange(currentDocument!, index: index)
        delegate?.pageDidChange(currentPage!, direction: 0)
    }
    
    /** updates current documents mark in its MarkBook object then writes to disk

    :param: mark the mark of the documet
    */
    func updateMark(mark: String) {
        let markBook = refArray.objectAtIndex(documentIndex) as? MarkBook
        markBook?.mark = mark
        writeFile()
    }
    
    /** writes .pmb file to disk in the document directory. Writes the url and mark of each document
    */
    func writeFile() {
        let file = "PDFMarkbook.pmb"
        if let dirs: [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
            let dir = dirs[0] //document directory
            let path = dir.stringByAppendingPathComponent(file)
            var text: String = ""
            if refArray.count > 0 {
                for document in refArray {
                    if let d = document as? MarkBook {
                        text += "\(d.url)"
                        text += "\u{000A}" //newline
                        text += d.mark
                        text += "\u{000A}"
                    }
                }
                text.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: nil);
            } else { //array count
                return
            }
        }
        
    }
    
    /** obtains current page from controller and checks if page is valid, updates model 
    then sends information back to controller for update
    :param: pageNumber the new pageNumber requested
    */
    func goToPage(pageNumber: String) {
        let number = pageNumber.toInt()
        let count = currentDocument!.pageCount()
        if number < 1 || number > count { return }
        pageHistory.addObject(currentPage!)
        previousPage = currentPage
        currentPage = currentDocument?.pageAtIndex(pageNumber.toInt()! - 1)
        let direction = getDirection(currentPage!, previous: previousPage!)
        delegate?.pageDidChange(currentPage!, direction: direction)
    }
    
    /** updates current page and sends new page to controller his function is used when
    navigating to page through the textfiled on user interface
    
    :param: the page requested
    */
    func updatePage(page: PDFPage) {
        var direction = getDirection(page, previous: currentPage!)
        previousPage = currentPage
        currentPage = page
        delegate?.pageDidChange(page, direction: direction)
    }
    
    /** uses current page in dex and previous page index to establish direction the user is navigating

    :param: current the current PDF page
    :param: previous the previous PDF page
    :return: direction the direction the user is navigating
    */
    func getDirection(current: PDFPage, previous: PDFPage) -> Int {
        if currentDocument?.indexForPage(current) > currentDocument?.indexForPage(previous){
            return 1
        } else {
            return -1
        }
    }
} //end class