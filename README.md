# CodyFire

[![Version](https://img.shields.io/cocoapods/v/CodyFire.svg?style=flat)](https://cocoapods.org/pods/CodyFire)

The lib which will convert your massive API calls code into the awesome convenient and easy maintainable controllers!

Use Codable models for everything related to API requests:
- payload
- multipart payload
- url query
- response

Wondered? That's only little part of what you will get from this lib! 🍻

## Quick examples

### How to send GET request

```swift
APIRequestWithoutPayload<ResultModel>("endpoint")
    .onSuccess { model in
    //here's your decoded model!
    //no need to check http.statusCode, I already did it for you! By default it's 200 OK
    //of course you can choose which statusCode is equal to success (look at the `POST` and `DELETE` examples below)
}
```

### How to send POST request

```swift
APIRequest<PayloadModel, ResultModel>("endpoint", payload: payloadModel)
    .method(.post)
    .desiredStatusCode(.created) //201 CREATED
    .onSuccess { model in
    //here's your decoded model!
    //success was determined by comparing desiredStatusCode with http.statusCode
}
```

### How to send DELETE request

```swift
APIRequestWithoutAnything("endpoint")
    .method(.delete)
    .desiredStatusCode(.noContent) //204 NO CONTENT
    .onSuccess { _ in
    //here's empty successful response!
    //success was determined by comparing desiredStatusCode with http.statusCode
}
```

Of course you'll be able to send PUT and PATCH requests, send multipart codable structs with upload progress callback, catch errors, even redefine error descriptions for every endpoint. Wondered? 😃 Let's read the whole readme below! 🍻

## How to install

CodyFire is available through [CocoaPods](https://cocoapods.org).

To install it, simply add the following line to your Podfile:
```ruby
pod 'CodyFire'
```

## How to setup

As CodyFire automatically detects which environment you're on I suggest you to use this awesome feature 👏 

```swift
import CodyFire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let dev = CodyFireEnvironment(baseURL: "http://localhost:8080")
        let testFlight = CodyFireEnvironment(baseURL: "https://stage.myapi.com")
        let appStore = CodyFireEnvironment(baseURL: "https://api.myapi.com")
        CodyFire.shared.configureEnvironments(dev: dev, testFlight: testFlight, appStore: appStore)
        //Also if you want to be able to switch environments manually just uncomment the line below (read more about that)
        //CodyFire.shared.setupEnvByProjectScheme()
        return true
    }
}
```

Isn't it a neat? 😏

### Declare you API controlelrs

I promise that this is API code architecture from your dreams which are come true!

#### Create an `API` folder and `API.swift` file inside it

```swift
import CodyFire

private let _APISharedInstance = API()

class API {
    public class var shared : API {
        return _APISharedInstance
    }
    
    let auth = AuthController()
    let task = TaskController()
}
```

#### Create a folder named `Controllers` inside `API` folder, and create a folder for each controller

`API/Controllers/Auth/Auth.swift`
```swift
class AuthController() {}
```
`API/Controllers/Task/Task.swift`
```swift
class TaskController() {}
```

#### Create an extension file for each controller's endpoint

##### Auth login as simple POST request

`API/Controllers/Auth/Auth+Login.swift`
```swift
import CodyFire

extension AuthController {
  struct LoginRequest: JSONPayload {
        let email, password: String
        init (email: String, password: String) {
            self.email = email
            self.password = password
        }
    }
    
    struct LoginResponse: Codable {
        var token: String
    }
  
    func login(_ request: LoginRequest) -> APIRequest<LoginRequest, LoginResponse> {
        return APIRequest("login", payload: request).method(.post)
            .addKnownError(.notFound, "User not found")
    }
}
```

##### Auth login for Basic auth

`API/Controllers/Auth/Auth+Login.swift`
```swift
import CodyFire

extension AuthController {
    struct LoginResponse: Codable {
        var token: String
    }
    
    func login(email: String, password: String) -> APIRequestWithoutPayload<LoginResponse> {
        return APIRequest("login").method(.post).basicAuth(email: email, password: password)
            .addKnownError(.notFound, "User not found")
    }
}
```

##### Task REST endpoints

###### Get task by id or a list of tasks by offset and limit

`API/Controllers/Task/Task+Get.swift`
```swift
import CodyFire

extension TaskController {
    struct Task: Codable {
        var id: UUID
        var name: String
    }
    
    struct ListQuery: Codable {
        var offset, limit: Int
        init (offset: Int, limit: Int) {
            self.offset = offset
            self.limit = limit
        }
    }
    
    func get(_ query: ListQuery? = nil) -> APIRequestWithoutPayload<[Task]> {
        return APIRequest("task").query(query)
    }
    
    func get(id: UUID) -> APIRequestWithoutPayload<Task> {
        return APIRequest("task/" + id.uuidString)
    }
}
```

###### Create a task

`API/Controllers/Task/Task+Create.swift`
```swift
import CodyFire

extension TaskController {
    struct CreateRequest: JSONPayload {
        var name: String
        init (name: String) {
            self.name = name
        }
    }
    
    func create(_ request: CreateRequest) -> APIRequest<CreateRequest, Task> {
        return APIRequest("post", payload: request).method(.post).desiredStatusCode(.created)
    }
}
```

###### Edit a task

`API/Controllers/Task/Task+Edit.swift`
```swift
import CodyFire

extension TaskController {
    struct EditRequest: JSONPayload {
        var name: String
        init (name: String) {
            self.name = name
        }
    }
    
    func create(id: UUID, request: EditRequest) -> APIRequest<EditRequest, Task> {
        return APIRequest("post/" + id.uuidString, payload: request).method(.patch)
    }
}
```

###### Delete a task

`API/Controllers/Task/Task+Delete.swift`
```swift
import CodyFire

extension TaskController {
    func delete(id: UUID) -> APIRequestWithoutAnything {
        return APIRequest("post/" + id.uuidString).method(.delete).desiredStatusCode(.noContent)
    }
}
```

### Easily use your API endpoints!

###### Send login request

```swift
API.shared.auth.login(email: "test@mail.com", password: "qwerty").onKnownError { error in
    switch error.code {
    case .notFound: print("User not found")
    default: print(error.description)
    }
}.onSuccess { token in
    print("Received auth token: "+ token)
}
```

###### Get a list of tasks

```swift
API.shared.task.get().onKnownError { error in
    print(error.description)
}.onSuccess { tasks in
    print("received \(tasks.count) tasks")
}
```

###### Create a task

```swift
API.shared.task.create(TaskController.CreateRequest(name: "Install CodyFire")).onKnownError { error in
    print(error.description)
}.onSuccess { task in
    print("just created new task: \(task)")
}
```

###### Delete a task

```swift
let taskId = UUID()
API.shared.task.delete(id: taskId).onKnownError { error in
    print(error.description)
}.onSuccess { _ in
    print("just removed task with id: \(taskId)")
}
```

### Multipart example

```swift
class PostController()
extension PostController {
    struct CreateRequest: MultipartPayload {
        var text: String
        var tags: [String]
        var images: [Attachment]
        var video: Data
        init (text: String, tags: [String], images: [Attachment], video: Data) {
            self.text = text
            self.tags = tags
            self.images = images
            self.video = video
        }
    }
    
    struct PostResponse: Codable {
        let text: String
        let tags: [String]
        let linksToImages: [String]
        let linkToVideo: String
    }
    
    func create(_ request: CreateRequest) -> APIRequest<CreateRequest, PostResponse> {
        return APIRequest("post", payload: request).method(.post)
    }
}

//then somewhere send create post request!

let videoData = FileManager.default.contents(atPath: "/path/to/video.mp4")!
let imageAttachment = Attachment(data: UIImage(named: "cat")!.jpeg(.high)!, 
                                 fileName: "cat.jpg",
                                 mimeType: .jpg)
let payload = PostController.CreateRequest(text: "CodyFire is awesome", 
                                           tags: ["codyfire", "awesome"],
                                           images: [imageAttachment],
                                           video: videoData)
API.shared.post.create(payload).onProgress { progress in
    print("tracking post uploading progress: \(progress)")
}.onKnownError { error in
    print(error.description)
}.onSuccess { createdPost in
    print("just created post: \(createdPost)")
}
```

Easy right? 🎉

## APIRequest methods

`//TO BE DONE`

## Author

Mike Isaev, isaev.mihael@gmail.com
