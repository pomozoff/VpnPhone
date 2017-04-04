import Foundation
import Security

// Constant Identifiers
let userAccount = "AuthenticatedUser"

/**
 *  User defined keys for new entry
 *  Note: add new keys for new secure item and use them in load and save methods
 */

// Arguments for the keychain queries
let kSecClassValue = String(format: kSecClass as String)
let kSecAttrAccountValue = String(format: kSecAttrAccount as String)
let kSecValueDataValue = String(format: kSecValueData as String)
let kSecClassGenericPasswordValue = String(format: kSecClassGenericPassword as String)
let kSecAttrServiceValue = String(format: kSecAttrService as String)
let kSecMatchLimitValue = String(format: kSecMatchLimit as String)
let kSecReturnDataValue = String(format: kSecReturnData as String)
let kSecMatchLimitOneValue = String(format: kSecMatchLimitOne as String)

public class KeychainService: NSObject {

    class func saveCertificate(named label: String, passphrase: String, data: Data) -> SecIdentity? {
        let options = [
            kSecImportExportPassphrase as String: passphrase,
            kSecAttrLabel as String: label
        ]

        var importResult: CFArray?
        let err = SecPKCS12Import(data as NSData, options as NSDictionary, &importResult)

        guard err == errSecSuccess else {
            print("Failed to save p12 to keychain: \(err)")
            return nil
        }

        let identityDictionaries = importResult as! [[String:Any]]
        let identity = identityDictionaries.first?[kSecImportItemIdentity as String] as! SecIdentity

        print("Saved p12: \(identity)")

        return identity
    }

    class func load(passphrase: String) -> Data? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: [String : Any] = [
            kSecClassValue: kSecClassIdentity,
            kSecAttrServiceValue: passphrase,
            kSecReturnDataValue: true,
            kSecMatchLimitValue: kSecMatchLimitOneValue
        ]

        /**
         * Internal methods for querying the keychain.
         */

        var dataTypeRef: AnyObject?

        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery as CFDictionary, &dataTypeRef)

        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                return retrievedData
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }

        return nil
    }
}
