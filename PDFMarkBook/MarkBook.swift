//
//  MarkBook.swift
//  PDFMarkBook
//
//  Created by Matt Wynyard on 30/09/15.
//  Copyright (c) 2015 Niobium. All rights reserved.
//

import Foundation
import Quartz

class MarkBook {
    
    private var _url: NSURL? = nil
    private var _mark: String? = nil
    
    var url: NSURL {
        get {
            return _url!
        }
    }
    
    var mark: String {
        get {
            if let m = _mark {
                return m
            } else {
                return ""
            }
        }
        set(newValue) {
            _mark = newValue
        }
    }
    
    init(url: NSURL, mark: String) {
        
        self._url = url
        self._mark = mark
    }
    
}
