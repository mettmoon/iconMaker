//
//  ViewController.swift
//  IconMaker
//
//  Created by Peter on 2016. 12. 12..
//  Copyright © 2016년 WEJOApps. All rights reserved.
//

import Cocoa
import Foundation

class ViewController: NSViewController {
    @IBOutlet weak var ivPreview: NSImageView!
    @IBOutlet weak var tfOutput: NSTextField!
    @IBOutlet weak var btnOutput:NSButton!
    @IBOutlet weak var btnConvert:NSButton!
    
    @IBAction func findOutputButtonPressed(_ sender: Any) {
        let panel = NSOpenPanel()
        panel.isFloatingPanel = true
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["png"]
        if panel.runModal() == .OK {
            let array = panel.urls
            if let url = array.first {
                self.tfOutput.stringValue = url.path
            }
        }
        
    }
    
    @IBAction func convertButtonPressed(_ sender: Any) {
        Thread.detachNewThreadSelector(#selector(convert), toTarget: self, with: nil)
        
    }
    @objc func convert(){
        guard let originalImage = self.ivPreview.image else {return}
//        var resizeImage:NSImage? = nil
        
        let iconSizeSetPath = Bundle.main.path(forResource: "appicon", ofType: "json")!
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: iconSizeSetPath)) else {return}
        
        guard let object = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] else {return}
        let imageInfoItems = object["images"] as! [[String:String]]
        
        let directoryPath = String(format: "%@/AppIcon.appiconset", self.tfOutput.stringValue)
        if !FileManager.default.fileExists(atPath: directoryPath) {
            try? FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
        }
        var exportJSONObject:[String:Any] = [:]
        exportJSONObject["info"] = object["info"]!
        var imagesJSON:[[String:String]] = []
        for imageInfoItem in imageInfoItems {
            let index = imageInfoItems.firstIndex(where: { (object:[String : String]) -> Bool in
                return object == imageInfoItem
            })!
//            let idiom = imageInfoItem["idiom"]!
            let size:CGSize = {
                guard let string = imageInfoItem["size"] else {return .zero}
                let strings = string.components(separatedBy: "x")
                let width = Double(strings.first!)!
                let height = Double(strings[1])!
                return CGSize(width: width, height: height)
            }()
            let scaleString = imageInfoItem["scale"]!.replacingOccurrences(of: "x", with: "")
            guard let n = NumberFormatter().number(from: scaleString) else {continue}
            
            let scale:CGFloat = CGFloat(truncating: n)
            let fileName = String(format: "%i.png", index)
            let filePath = String(format: "%@/%@", directoryPath,fileName)
            var infoJSON = imageInfoItem
            infoJSON["filename"] = fileName
            imagesJSON.append(infoJSON)
            
            
            let resizeImage = originalImage.resizedImage(size, scale: scale)
            self.saveImageFile(resizeImage, with: filePath)
            
        }
        exportJSONObject["images"] = imagesJSON

        if let data = try? JSONSerialization.data(withJSONObject: exportJSONObject, options: JSONSerialization.WritingOptions.prettyPrinted) {
            let converString = String(data: data, encoding: .utf8)
            let filePath = String(format:"%@/Contents.json",directoryPath)
            try? converString?.write(toFile: filePath, atomically: true, encoding: .utf8)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    func saveImageFile(_ image:NSImage, with filePath:String){
        guard let tiffData = image.tiffRepresentation else {return}
        let imageRep = NSBitmapImageRep(data: tiffData)
        guard let pngData = imageRep?.representation(using: .png, properties: [:]) else {return }
        let url = URL(fileURLWithPath: filePath)
        
        do {
            try pngData.write(to: url)
        } catch{
            print(error)
        
        }
    }

}

extension NSImage {
    func resizedImage(_ size:CGSize, scale ratio:CGFloat) -> NSImage {
        let scaledSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let resizeImage = NSImage(size: scaledSize)
        resizeImage.lockFocus()
        let originalImage = self
        originalImage.size = scaledSize
        NSGraphicsContext.current?.imageInterpolation = .high
        let fromRect = NSRect(x: 0, y: 0, width: originalImage.size.width, height: originalImage.size.height)
        originalImage.draw(at: .zero, from: fromRect, operation: .copy, fraction: 1)
        resizeImage.unlockFocus()
        return resizeImage
    }
    
}
