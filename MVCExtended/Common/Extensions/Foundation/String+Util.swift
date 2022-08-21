import Foundation

extension Optional where Wrapped == String {
    
    func isNullOrBlank() -> Bool {
        return self == nil || self!.isBlank
    }
    
}

enum StringCapitalizationOptions {
    case noun
    case midSentence
    case startOfSentence
}

extension String {
    
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isNotBlank: Bool {
        return !self.isBlank
    }
    
    func ifBlank(_ defaultValue: String) -> String {
        return isBlank ? defaultValue : self
    }
    
    func isEmpty(_ defaultValue: String) -> String {
        return isEmpty ? defaultValue : self
    }
    
    func removing(_ characters: CharacterSet) -> String {
        return components(separatedBy: characters).joined()
    }
    
    func replacing(_ oldValue: String, with newValue: String, options: CompareOptions = []) -> String {
        return self.replacingOccurrences(of: oldValue, with: newValue, options: options)
    }
    
    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }
    
    func base64Decoded() -> String? {
        // FIXME: This must be fixed in the backend!
        // Base64 string length must be a multiple of 4. Should be padded with '=' characters.
        let length = lengthOfBytes(using: .utf8)
        let missingPadding = (length % 4 != 0) ? 4 - length % 4 : 0
        let base64 = self + String(repeating: "=", count: missingPadding)
        guard let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) else { return nil }
        return String(data: data, encoding: .utf8)!
    }
    
    func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func convertToAttributedString() -> NSAttributedString? {
        let modifiedFontString = "<span style=\"font-family: Lato-Regular; font-size: 16; color: rgb(60, 60, 60)\">" + self + "</span>"
        return modifiedFontString.htmlToAttributedString
    }
    
    
    func getCleanedURL() -> URL? {
        guard self.isEmpty == false else {
            return nil
        }
        if let url = URL(string: self) {
            return url
        } else {
            if let urlEscapedString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) , let escapedURL = URL(string: urlEscapedString){
                return escapedURL
            }
        }
        return nil
     }
    
    func toURL() -> URL? {
        return URL(string: self)
    }
}

extension Substring {
    
    func toString() -> String {
        return String(self)
    }
    
    func split(separators: Character...) -> [String] {
        return components(separatedBy: CharacterSet(charactersIn: String(separators)))
    }
    
}

extension StringProtocol {
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
}
