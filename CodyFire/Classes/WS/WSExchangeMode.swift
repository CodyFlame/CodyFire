public enum WSExchangeMode {
    /// all the messages will be sent and received as `text`
    case text
    
    /// all the messages will be sent and received as `binary data`
    case binary
    
    /// default mode
    /// `binary data` will be sent and received as is
    /// `text` will be sent and received as is
    case both
}
