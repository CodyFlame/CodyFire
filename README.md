# CodyFire

[![Version](https://img.shields.io/cocoapods/v/CodyFire.svg?style=flat)](https://cocoapods.org/pods/CodyFire)

The lib which will convert your massive API calls code into the awesome convenient and easy maintainable controllers!

Use Codable struct for everything related to API requests, for such things like:
- payload
- multipart payload
- url query
- response

### Quick examples

#### How to send GET request

```swift
APIRequestWithoutPayload<ResultModel>("endpoint")
    .onSuccess { model in
    //here's your decoded model!
    //no need to check http.statusCode, I already did it for you!
    //of course you can choose which statusCode is equal to success (look at the `POST` and `DELETE` examples below)
}
```

#### How to send POST request

```swift
APIRequest<PayloadModel, ResultModel>("endpoint", payload: payloadModel)
    .method(.post)
    .desiredStatusCode(201)
    .onSuccess { model in
    //here's your decoded model!
    //success was determined by comparing desiredStatusCode with http.statusCode
}
```

#### How to send DELETE request

```swift
APIRequestWithoutAnything("endpoint")
    .method(.delete)
    .desiredStatusCode(204)
    .onSuccess { _ in
    //here's empty successful response!
    //success was determined by comparing desiredStatusCode with http.statusCode
}
```

Of course you'll be able to send PUT and PATCH requests, send multipart codable structs with upload progress callback, catch errors, even redefine error descriptions for every endpoint. Wondered? 😃 Let's read the whole readme below! 🍻

### How to install

```ruby
pod 'CodyFire'
```

### How to setup

As CodyFire automatically detect which environment you're on right now I suggest you to use this awesome feature 👏 

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

#### Declare you API controlelrs

What is that for? I promise that this is API code architecture from your dreams which is come true!

##### Create a file `API.swift` inside `API` folder

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

Then create a folder named `Controllers` inside `API` folder, and create a folder for each controller

`API/Controllers/Auth/Auth.swift`
```swift
class AuthController() {}
```
`API/Controllers/Task/Task.swift`
```swift
class TaskController() {}
```

Then create an extension file for each controller's endpoint

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
    
    func get(_ query: ListQuery) -> APIRequestWithoutPayload<[Task]> {
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
        return APIRequest("post", payload: request).method(.post)
    }
}
```

###### Edit a task

`API/Controllers/Task/Task+Create.swift`
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
        return APIRequest("post", payload: request).method(.post)
    }
}
```


```swift
import CodyFire

class TestControler() {
  func test() -> {
  
  }
}

```


To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CodyFire is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CodyFire'
```

## Author

MihaelIsaev, isaev.mihael@gmail.com

## License

CodyFire is available under the MIT license. See the LICENSE file for more info.
