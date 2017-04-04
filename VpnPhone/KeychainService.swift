import Foundation
import Security

public class KeychainService: NSObject {

    class func saveCertificate(named label: String, passphrase: String, data: Data) -> SecIdentity? {
        let query = [
            kSecImportExportPassphrase as String: passphrase,
            kSecAttrLabel as String: label
        ]

        var importResult: CFArray?
        let status = SecPKCS12Import(data as NSData, query as NSDictionary, &importResult)

        guard status == errSecSuccess else {
            print("Failed to save p12 to keychain: \(status)")
            return nil
        }

        let identityDictionaries = importResult as! [[String : Any]]
        let identity = identityDictionaries.first?[kSecImportItemIdentity as String] as! SecIdentity

        print("Saved p12: \(identity)")

        return identity
    }

    class func loadCertificate(named label: String, passphrase: String) -> Data? {
        let query: [String : Any] = [
            kSecClass as String: kSecClassCertificate,
            kSecAttrLabel as String: label,
            kSecMatchLimit as String: kSecMatchLimitAll,
            kSecReturnRef as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess else {
            print("Failed to find a certificate in keychain: \(status)")
            return nil
        }

        print("Loaded certificate from a keychain: \(String(describing: result))")

        return nil
    }

}
