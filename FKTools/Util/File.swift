//
//  File.swift
//  FKTools
//
//  Created by 风筝 on 2017/10/9.
//  Copyright © 2017年 Doge Studio. All rights reserved.
//

import UIKit

enum FileError: Error {
    case fileNotFound
    case isNotDirectory
    case isNotFile
    case destinationAlreadyExists
    case unknown
}

public class File: NSObject {
    
    public let path: String
    public let parentPath: String
    public let filename: String
    public let filetype: String
    
    public var isExists: Bool {
        get {
            return FileManager.default.fileExists(atPath: self.path)
        }
    }
    public var isDirectory: Bool {
        get {
            var isDir = ObjCBool(false)
            _ = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
            return isDir.boolValue
        }
    }
    
    public init(path: String) {
        self.path = path
        if let range = self.path.range(of: "/", options: .backwards, range: nil, locale: nil) {
            self.parentPath = String(path[..<range.upperBound])
            self.filename = String(path[range.upperBound...])
            if let range = self.filename.range(of: ".", options: .backwards, range: nil, locale: nil) {
                self.filetype = String(self.filename[range.upperBound])
            } else {
                self.filetype = ""
            }
        } else {
            self.parentPath = ""
            self.filename = ""
            self.filetype = ""
        }
        super.init()
    }
    
    fileprivate override init() {
        self.path = ""
        self.parentPath = ""
        self.filename = ""
        self.filetype = ""
        super.init()
    }
    
    public func getData() -> Data? {
        if self.isDirectory {
            return nil
        }
        let url = URL(fileURLWithPath: self.path)
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Get data of \"\(self.path)\" failed: \(error)")
            return nil
        }
    }
    
    public func getFileSize() -> UInt64 {
        do {
            let attributes = try self.getAttributes() as NSDictionary
            return attributes.fileSize()
        } catch {
            print("Get fileSize of \"\(self.path)\" failed: \(error)")
            return 0
        }
    }
    
    public func getCreationDate() -> Date? {
        do {
            let attributes = try self.getAttributes() as NSDictionary
            return attributes.fileCreationDate()
        } catch {
            print("Get creation date of \"\(self.path)\" failed: \(error)")
            return nil
        }
    }
    
    public func getModificationDate() -> Date? {
        do {
            let attributes = try self.getAttributes() as NSDictionary
            return attributes.fileModificationDate()
        } catch {
            print("Get modification date of \"\(self.path)\" failed: \(error)")
            return nil
        }
    }
    
    public func getAttributes() throws -> [FileAttributeKey: Any] {
        return try FileManager.default.attributesOfItem(atPath: self.path)
    }
    
    public func move(to path: String) throws -> File {
        try FileManager.default.moveItem(atPath: self.path, toPath: path)
        let newFile = File(path: path)
        if self.isExists || !newFile.isExists {
            throw FileError.unknown
        } else {
            return newFile
        }
    }
    
    public func copy(to path: String) throws -> File {
        try FileManager.default.copyItem(atPath: self.path, toPath: path)
        let newFile = File(path: path)
        if !newFile.isExists {
            throw FileError.unknown
        } else {
            return newFile
        }
    }
    
    public func rename(to filename: String) throws -> File {
        return try self.move(to: self.parentPath.appending(filename))
    }
    
    /// Delete the file at the path of self
    /// - returns: true if the file was delete successfully. Returns false if an error occured or the file is not exists.
    public func delete() -> Bool {
        do {
            let exists = self.isExists
            try FileManager.default.removeItem(atPath: self.path)
            return exists != self.isExists
        } catch {
            print("Delete file \"\(self.path)\" failed: \(error)")
            return false
        }
    }
    
}
