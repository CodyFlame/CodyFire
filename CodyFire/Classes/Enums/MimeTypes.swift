//
//  MimeTypes.swift
//  CodyFire
//
//  Created by Mihael Isaev on 10.08.2018.
//

import Foundation

public struct MimeType: ExpressibleByStringLiteral {
    public let value: String
    
    public init (_ value: String) {
        self.value = value
    }
    
    public init(stringLiteral value: String) {
        self.value = value
    }
    
    ///AAC audio file
    public static var aac: Self { "audio/aac" }
    ///AVI: Audio Video Interleave
    public static var avi: Self { "video/x-msvideo" }
    ///Any kind of binary data
    public static var bin: Self { "application/octet-stream" }
    ///BZip archive
    public static var bz: Self { "application/x-bzip" }
    ///BZip2 archive
    public static var bz2: Self { "application/x-bzip2" }
    ///C-Shell script
    public static var csh: Self { "application/x-csh" }
    ///Cascading Style Sheets (CSS)
    public static var css: Self { "text/css" }
    ///Comma-separated values (CSV)
    public static var csv: Self { "text/csv" }
    ///Microsoft Word
    public static var doc: Self { "application/msword" }
    ///MS Embedded OpenType fonts
    public static var eot: Self { "application/vnd.ms-fontobject" }
    ///Electronic publication (EPUB)
    public static var epub: Self { "application/epub+zip" }
    ///Graphics Interchange Format (GIF)
    public static var gif: Self { "image/gif" }
    ///HyperText Markup Language (HTML)
    public static var html: Self { "text/html" }
    ///Icon format
    public static var ico: Self { "image/x-icon" }
    ///iCalendar format
    public static var ics: Self { "text/calendar" }
    ///Java Archive (JAR)
    public static var jar: Self { "application/java-archive" }
    ///JPEG images
    public static var jpg: Self { "image/jpeg" }
    ///JavaScript (ECMAScript)
    public static var js: Self { "application/javascript" }
    ///JSON format
    public static var json: Self { "application/json" }
    ///Musical Instrument Digital Interface (MIDI)
    public static var midi: Self { "audio/midi" }
    ///MPEG Video
    public static var mpeg: Self { "video/mpeg" }
    ///Apple Installer Package
    public static var mpkg: Self { "application/vnd.apple.installer+xml" }
    ///OpenDocuemnt presentation document
    public static var odp: Self { "application/vnd.oasis.opendocument.presentation" }
    ///OpenDocuemnt spreadsheet document
    public static var ods: Self { "application/vnd.oasis.opendocument.spreadsheet" }
    ///OpenDocument text document
    public static var odt: Self { "application/vnd.oasis.opendocument.text" }
    ///OGG audio
    public static var oga: Self { "audio/ogg" }
    ///OGG video
    public static var ogv: Self { "video/ogg" }
    ///OGG
    public static var ogx: Self { "application/ogg" }
    ///OpenType font
    public static var otf: Self { "font/otf" }
    ///Portable Network Graphics
    public static var png: Self { "image/png" }
    ///Adobe Portable Document Format (PDF)
    public static var pdf: Self { "application/pdf" }
    ///Microsoft PowerPoint
    public static var ppt: Self { "application/vnd.ms-powerpoint" }
    ///RAR archive
    public static var rar: Self { "application/x-rar-compressed" }
    ///Rich Text Format (RTF)
    public static var rtf: Self { "application/rtf" }
    ///Bourne shell script
    public static var sh: Self { "application/x-sh" }
    ///Scalable Vector Graphics (SVG)
    public static var svg: Self { "image/svg+xml" }
    ///Small web format (SWF) or Adobe Flash document
    public static var swf: Self { "application/x-shockwave-flash" }
    ///Tape Archive (TAR)
    public static var tar: Self { "application/x-tar" }
    ///Tagged Image File Format (TIFF)
    public static var tiff: Self { "image/tiff" }
    ///Typescript file
    public static var ts: Self { "video/vnd.dlna.mpeg-tts" }
    ///TrueType Font
    public static var ttf: Self { "font/ttf" }
    ///Microsoft Visio
    public static var vsd: Self { "application/vnd.visio" }
    ///Waveform Audio Format
    public static var wav: Self { "audio/x-wav" }
    ///WEBM audio
    public static var weba: Self { "audio/webm" }
    ///WEBM video
    public static var webm: Self { "video/webm" }
    ///WEBP image
    public static var webp: Self { "image/webp" }
    ///Web Open Font Format (WOFF)
    public static var woff: Self { "font/woff" }
    ///Web Open Font Format (WOFF)
    public static var woff2: Self { "font/woff2" }
    ///XHTML
    public static var xhtml: Self { "application/xhtml+xml" }
    ///Microsoft Excel
    public static var xls: Self { "application/vnd.ms-excel" }
    ///XML
    public static var xml: Self { "application/xml" }
    ///XUL
    public static var xul: Self { "application/vnd.mozilla.xul+xml" }
    ///ZIP archive
    public static var zip: Self { "application/zip" }
}

extension MimeType: Equatable {
    public static func == (lhs: MimeType, rhs: MimeType) -> Bool {
        return lhs.value == rhs.value
    }
}
