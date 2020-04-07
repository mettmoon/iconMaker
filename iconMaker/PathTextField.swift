//
//  PathTextField.swift
//  IconMaker
//
//  Created by Peter on 2016. 12. 12..
//  Copyright © 2016년 WEJOApps. All rights reserved.
//

import Cocoa
extension NSNotification.Name {
    static let filePathChanged = NSNotification.Name("FilePathChanged")
}
class PathTextField: NSTextField {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(filePathChanged(notification:)), name: .filePathChanged, object: nil)
        
    }
    @objc func filePathChanged(notification:Notification){
        var path = notification.object as! String
        
        guard let index = path.range(of: "/", options: String.CompareOptions.backwards, range: nil, locale: nil)?.lowerBound else {return}

        path = String(path[..<index])
        self.stringValue = path
    }
}
