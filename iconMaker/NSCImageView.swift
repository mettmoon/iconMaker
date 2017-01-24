//
//  NSCImageView.swift
//  IconMaker
//
//  Created by Peter on 2016. 12. 12..
//  Copyright © 2016년 WEJOApps. All rights reserved.
//

import Cocoa

class NSCImageView: NSImageView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let a = (NSDragOperation.generic.rawValue & sender.draggingSourceOperationMask().rawValue)
        if a == NSDragOperation.generic.rawValue {
            return .generic
        }else{
            return NSDragOperation.init(rawValue: 0)
        }
    }
    override func draggingExited(_ sender: NSDraggingInfo?) {
//        self.print(sender)
    }
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pboard = sender.draggingPasteboard()
        if pboard.types?.contains(NSFilenamesPboardType) == true {
            let files = pboard.propertyList(forType: NSFilenamesPboardType)
//            self.print(files)
        }
        let types = [NSTIFFPboardType, NSFilenamesPboardType]
        guard let desiredType = pboard.availableType(from: types) else {return false}
        guard let carriedData = pboard.data(forType: desiredType) else{
            let myPopup: NSAlert = NSAlert()
            myPopup.messageText = "Sorry, but the past operation failed"
            myPopup.informativeText = "Paste Error"
            myPopup.alertStyle = NSAlertStyle.warning
            myPopup.addButton(withTitle: "OK")
            myPopup.runModal()
            return false
        }
        
        if desiredType == NSTIFFPboardType {
            let newImage = NSImage(data: carriedData)
            self.image = newImage
        }else if desiredType == NSFilenamesPboardType {
            guard let files = pboard.propertyList(forType: NSFilenamesPboardType) as? [Any] else {return false}
            guard let path = files.first as? String else {return false}
            NotificationCenter.default.post(name: .filePathChanged, object: path)
            guard let newImage = NSImage(contentsOfFile: path) else {
                let myPopup: NSAlert = NSAlert()
                let str = String(format: "Sorry, but I failed to open the file at \"%@\"", path)
                myPopup.messageText = str
                myPopup.informativeText = "File Reading Error"
                myPopup.alertStyle = NSAlertStyle.warning
                myPopup.addButton(withTitle: "OK")
                myPopup.runModal()
                return false

            }
            self.image = newImage
            
        }else{
            assert(false, "this can't happen")
            return false
        }
        self.needsDisplay = true
        return true
    }
    /*
 
  {
 //the pasteboard was able to give us some meaningful data
 if ([desiredType isEqualToString:NSTIFFPboardType])
 {
 //we have TIFF bitmap data in the NSData object
 NSImage *newImage = [[NSImage alloc] initWithData:carriedData];
 [self setImage:newImage];
 //we are no longer interested in this so we need to release it
 }
 else if ([desiredType isEqualToString:NSFilenamesPboardType])
 {
 //we have a list of file names in an NSData object
 NSArray *fileArray =
 [paste propertyListForType:@"NSFilenamesPboardType"];
 //be caseful since this method returns id.
 //We just happen to know that it will be an array.
 NSString *path = [fileArray objectAtIndex:0];
 [[NSNotificationCenter defaultCenter] postNotificationName:@"FilePathChanged" object:path];
 //assume that we can ignore all but the first path in the list
 NSImage *newImage = [[NSImage alloc] initWithContentsOfFile:path];
 
 if (nil == newImage)
 {
 //we failed for some reason
 NSRunAlertPanel(@"File Reading Error",
 @"Sorry, but I failed to open the file at \"%@\"", nil, nil, nil,path);
 return NO;
 }
 else
 {
 //newImage is now a new valid image
 [self setImage:newImage];
 }
 }
 else
 {
 //this can't happen
 NSAssert(NO, @"This can't happen");
 return NO;
 }
 }
 [self setNeedsDisplay:YES];    //redraw us with the new image
 return YES;
 }
 
*/
}
