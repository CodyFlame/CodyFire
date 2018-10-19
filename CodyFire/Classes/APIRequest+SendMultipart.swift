//
//  APIRequest+SendMultipart.swift
//  CodyFire
//
//  Created by Mihael Isaev on 16/10/2018.
//

import Foundation
import Alamofire

extension APIRequest {
    func sendMultipartEncoded() {
        guard let payload = payload as? MultipartPayload else { return } //TODO: throw
        SessionManager.default.upload(multipartFormData: { multipart in
            let mirror = Mirror(reflecting: payload)
            mirror.children.forEach { children in
                if let key = children.label {
                    if let attachments = children.value as? [Attachment] {
                        attachments.forEach { attachment in
                            multipart.append(attachment.data, withName: key + "[]", fileName: attachment.fileName, mimeType: attachment.mimeType)
                        }
                    } else if let attachment = children.value as? Attachment {
                        multipart.append(attachment.data, withName: key, fileName: attachment.fileName, mimeType: attachment.mimeType)
                    } else if let dataArray = children.value as? [Data] {
                        dataArray.forEach { data in
                            multipart.append(data, withName: key + "[]")
                        }
                    } else if let data = children.value as? Data {
                        multipart.append(data, withName: key)
                    } else if let string = children.value as? String {
                        guard let data = string.data(using: .utf8) else {
                            return //TODO: throw unable to encode error
                        }
                        multipart.append(data, withName: key)
                    } else if let strings = children.value as? [String] {
                        strings.forEach { string in
                            guard let data = string.data(using: .utf8) else {
                                return //TODO: throw unable to encode error
                            }
                            multipart.append(data, withName: key)
                        }
                    } else if let array = children.value as? [Any] {
                        array.forEach { object in
                            guard let data = String(describing: object).data(using: .utf8) else {
                                return //TODO: throw unable to encode error
                            }
                            multipart.append(data, withName: key)
                        }
                    } else {
                        guard let data = String(describing: children.value).data(using: .utf8) else {
                            return //TODO: throw unable to encode error
                        }
                        multipart.append(data, withName: key)
                    }
                }
            }
        }, to: url, method: .post, headers: headers) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.response { response in
                    self.parseResponse(response)
                }
                upload.uploadProgress { progress in
                    self.progressCallback?(progress.fractionCompleted)
                }
            case .failure(let encodingError):
                self.parseError(0, encodingError, nil, "Unable to execute request")
                self.logError(statusCode: 0, error: encodingError, data: nil)
            }
        }
    }
}
