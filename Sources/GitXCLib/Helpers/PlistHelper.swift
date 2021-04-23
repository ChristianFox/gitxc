

import Foundation

/// Extracts data from Plist files
public class PlistHelper {
	
	/**
	Extract a dictionary from a plist file with the given name in the given directory
	
	- Parameter name: The file name
	- Parameter directoryPath: The directory path when the file resides
	- Returns: A dictionary or nil
	*/
    public class func plistDictionaryWithFileName(_ name: String, directoryPath: String) throws -> [String:Any]? {
        
        let localURL = URL(fileURLWithPath: directoryPath + name + ".plist")
        return try plistDictionaryFromURL(localURL)
    }

	/**
	Extract a dictionary from a plist file at the given URL
	
	- Parameter url: The file URL
	- Returns: A dictionary or nil
	*/
    public class func plistDictionaryFromURL(_ url: URL) throws -> [String:Any]? {
        try propertyList(from: url) as? [String:Any]
    }

	/**
	Extract an array from a plist file with the given name in the given directory
	
	- Parameter name: The file name
	- Parameter directoryPath: The directory path when the file resides
	- Returns: An array or nil
	*/
    public class func plistArrayWithFileName(_ name: String, directoryPath: String) throws -> [Any]? {
        let localURL = URL(fileURLWithPath: directoryPath + name + ".plist")
        return try plistArrayFromURL(localURL)
    }
	
	/**
	Extract an array from a plist file at the given URL
	
	- Parameter url: The file URL
	- Returns: An array or nil
	*/
    public class func plistArrayFromURL(_ url:URL) throws -> [Any]? {
        try propertyList(from: url) as? [Any]
    }

    /// Extract Property List contents
    public class func propertyList(from url: URL) throws -> Any? {
        
        var propertyListFormat: PropertyListSerialization.PropertyListFormat =  .xml
        guard let plistData = FileManager.default.contents(atPath: url.path) else {
            return nil
        }
        return try PropertyListSerialization.propertyList(from: plistData, options: .mutableContainersAndLeaves, format: &propertyListFormat)
    }

}
