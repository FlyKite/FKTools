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
        if let range = self.path.range(of: "\\", options: .backwards, range: nil, locale: nil) {
            self.parentPath = self.path.substring(to: range.upperBound)
        } else {
            self.parentPath = ""
        }
        if let range = self.path.range(of: "\\", options: .backwards, range: nil, locale: nil) {
            self.filename = self.path.substring(from: range.upperBound)
        } else {
            self.filename = ""
        }
        if let range = self.path.range(of: ".", options: .backwards, range: nil, locale: nil) {
            self.filetype = self.path.substring(from: range.upperBound)
        } else {
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
    
    public func move(to path: String) throws -> File {
        do {
            try FileManager.default.moveItem(atPath: self.path, toPath: path)
            let newFile = File(path: path)
            if self.isExists || !newFile.isExists {
                throw FileError.unknown
            } else {
                return newFile
            }
        } catch {
            throw error
        }
    }
    
    public func copy(to path: String) throws -> File {
        do {
            try FileManager.default.copyItem(atPath: self.path, toPath: path)
            let newFile = File(path: path)
            if !newFile.isExists {
                throw FileError.unknown
            } else {
                return newFile
            }
        } catch {
            throw error
        }
    }
    
    public func rename(to filename: String) throws -> File {
        do {
            return try self.move(to: self.parentPath.appending(filename))
        } catch {
            throw error
        }
    }
    
    /// Delete the file at the path of self
    /// - returns: true if the file was delete successfully. Returns false if an error occured or the file is not exists.
    public func delete() -> Bool {
        do {
            let exists = self.isExists
            try FileManager.default.removeItem(atPath: self.path)
            return exists != self.isExists
        } catch {
            return false
        }
    }
    
}
