//
//  URLSessionHTTPAdapter.swift
//  CodyFire
//
//  Created by Mihael Isaev on 05.06.2021.
//

import Foundation

#if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
class URLSessionHTTPAdapter: NSObject, HTTPAdapter, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionStreamDelegate, URLSessionDownloadDelegate {
    lazy var session: URLSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
    
    class StoredAdapterCall {
        let startedAt = Date()
        let progress: ((Double) -> Void)?
        let callback: (Result<HTTPAdapterResponse, Error>) -> Void
        
        lazy var receivedData = Data()
        
        init (progress: ((Double) -> Void)?, callback: @escaping (Result<HTTPAdapterResponse, Error>) -> Void) {
            self.progress = progress
            self.callback = callback
        }
    }
    var tasks: [URLSessionTask: StoredAdapterCall] = [:]
    
    func cancel(_ req: AnyHTTPAdapterRequest) {
        
    }
    
    func request(_ req: HTTPAdapterRequest, _ progress: ((Double) -> Void)?, _ callback: @escaping (Result<HTTPAdapterResponse, Error>) -> Void) {
        var request = URLRequest(url: req.url)
        req.headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.allowsCellularAccess = req.allowsCellularAccess
        if #available(OSX 10.15, iOS 13.0, *) {
            request.allowsExpensiveNetworkAccess = req.allowsExpensiveNetworkAccess
            request.allowsConstrainedNetworkAccess = req.allowsConstrainedNetworkAccess
        }
        request.cachePolicy = req.cachePolicy
        request.timeoutInterval = req.timeoutInterval
        request.httpMethod = req.method.value
        request.httpShouldHandleCookies = req.httpShouldHandleCookies
        request.httpShouldUsePipelining = req.httpShouldUsePipelining
        request.networkServiceType = .default // req.networkServiceType.rawValue
        let task: URLSessionTask
        switch req.mode {
        case .api:
            switch req.body {
            case .file(let fileURL):
                task = session.uploadTask(with: request, fromFile: fileURL)
            case .data(let data):
                request.httpBody = data
                task = session.dataTask(with: request)
            case .stream(let inputStream):
                request.httpBodyStream = inputStream
                task = session.dataTask(with: request)
            case .none:
                task = session.dataTask(with: request)
            }
        case .upload:
            switch req.body {
            case .file(let fileURL):
                task = session.uploadTask(with: request, fromFile: fileURL)
            case .data(let data):
                task = session.uploadTask(with: request, from: data)
            case .stream(let inputStream):
                request.httpBodyStream = inputStream
                task = session.uploadTask(withStreamedRequest: request)
            case .none:
                task = session.dataTask(with: request)
            }
        case .download:
            task = session.downloadTask(with: request)
        }
        tasks[task] = .init(progress: progress, callback: callback)
        task.resume()
    }
    
    // MARK: - URLSessionDelegate
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        debugPrint("URLSession didBecomeInvalidWithError")
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        debugPrint("URLSession didReceive challenge")
        completionHandler(.performDefaultHandling, nil)
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        debugPrint("URLSession urlSessionDidFinishEvents")
    }
    
    // MARK: - URLSessionTaskDelegate
    
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        debugPrint("URLSession taskIsWaitingForConnectivity")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        debugPrint("URLSession didCompleteWithError error: \(error)")
        guard let base = tasks[task] else { debugPrint("URLSession bug 1"); return } // TODO:
        guard let response = task.response as? HTTPURLResponse else {
            base.callback(.failure(CodyFireError("No internet connection")))
            return
        } // TODO:
        var headers: [String: String] = [:]
        response.allHeaderFields.forEach { key, value in
            guard let value = value as? String else { return }
            headers["\(key)"] = value
        }
        base.callback(
            .success(
                .init(
                    statusCode: .init(response.statusCode),
                    headers: headers,
                    body: base.receivedData,
                    error: error,
                    timeline: .init(startedAt: base.startedAt, endedAt: Date())
                )
            )
        )
    }
    
    @available(OSX 10.12, *)
    @available(iOS 10.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        debugPrint("URLSession task didFinishCollecting")// \(metrics)")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
        debugPrint("URLSession task needNewBodyStream")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        debugPrint("URLSession task didSendBodyData bytesSent: \(bytesSent) totalBytesSent: \(totalBytesSent) totalBytesExpectedToSend: \(totalBytesExpectedToSend)")
    }
    
//    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        debugPrint("URLSession task didReceive challenge \(challenge)")
//        completionHandler(.performDefaultHandling, nil)
//    }
    
    @available(OSX 10.13, *)
    @available(iOS 11.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) {
        debugPrint("URLSession task willBeginDelayedRequest")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        debugPrint("URLSession task willPerformHTTPRedirection")
        completionHandler(request)
    }
    
    // MARK: - URLSessionDataDelegate
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        debugPrint("URLSession dataTask didReceive data")
        guard let base = tasks[dataTask] else { return } // TODO:
        base.receivedData.append(data)
    }
    
    @available(OSX 10.11, *)
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
        debugPrint("URLSession dataTask didBecome streamTask")
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        debugPrint("URLSession dataTask didBecome downloadTask")
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        debugPrint("URLSession dataTask didReceive response")
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        debugPrint("URLSession dataTask willCacheResponse proposedResponse")
        completionHandler(nil)
    }
    
    // MARK: - URLSessionDownloadDelegate
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        debugPrint("URLSession downloadTask didWriteData")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        debugPrint("URLSession downloadTask didFinishDownloadingTo \(location)")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        debugPrint("URLSession downloadTask didResumeAtOffset")
    }
    
    // MARK: - URLSessionStreamDelegate
    
    @available(OSX 10.11, *)
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, readClosedFor streamTask: URLSessionStreamTask) {
        debugPrint("URLSession streamTask readClosedFor")
    }
    
    @available(OSX 10.11, *)
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, writeClosedFor streamTask: URLSessionStreamTask) {
        debugPrint("URLSession streamTask writeClosedFor")
    }
    
    @available(OSX 10.11, *)
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, betterRouteDiscoveredFor streamTask: URLSessionStreamTask) {
        debugPrint("URLSession streamTask betterRouteDiscoveredFor")
    }
    
    @available(OSX 10.11, *)
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream) {
        debugPrint("URLSession streamTask didBecome inputStream outputStream")
    }
}
#endif
