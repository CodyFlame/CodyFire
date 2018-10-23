# CodyFire ❤️

[![Version](https://img.shields.io/cocoapods/v/CodyFire.svg?style=flat)](https://cocoapods.org/pods/CodyFire)

## Intro

This lib was developed after facing with a lot of messy API calls code
Using it you will be able to make API calls code super clean in your iOS project

## The problem

That's how you're usially send API requests:
- you have to write request code
- put some payload into request (especially it's really not-trivial with multipart)
- send request (ideally with checking network availability)
- check request's response status code and if everything is ok then decode the result, otherwise catch and throw and error.

In case if you haven't developed some wrapper this code may look really massive.
And I believe that all of you, who now reading that text already have your own solution, some special classes and decorators to solve that problem, but believe you'll love my solution, because it's really awesome!

## So what you suggest?

Since Swift 4 we're able to use Codable structs/classes in our projects and they're really awesome.
And it's really awesome to use Codable for API request payload and response, isn't it?

## Stop talking! Show me what you have!

### How to use

#### 0️⃣ Preparing. Setup you API URLs in AppDelegate.

```swift
import UIKit
import CodyFire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navigationController = UINavigationController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupCodyfire()
        return true
    }
}

extension AppDelegate {
    func setupCodyfire() {
        let dev = CodyFireEnvironment(baseURL: "http://localhost:8080")
        let testFlight = CodyFireEnvironment(baseURL: "https://stage.myapi.com")
        let appStore = CodyFireEnvironment(baseURL: "https://api.myapi.com")
        CodyFire.shared.configureEnvironments(dev: dev, testFlight: testFlight, appStore: appStore)
    }
}
```

As you may see CodyFire will take care about automatic detection which environment you're on right now, isn't it a neat? ❤️

#### 1️⃣ Define your API calls using controllers

Create your API class named `API.swift` inside `API` folder

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
