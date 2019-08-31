# Flickr Image
Flickr Image project is an application contains a search page where users can enter queries, such as "kittens". The Flickr API results are shown in a 3-column endless scrollable view. 

### Table of Contents
**[Getting Started](#getting-started)**<br>
**[Decisions](#decisions)**<br>
**[Architecture](#architecture)**<br>
**[Image Caching Solution](#image_caching_solution)**<br>
**[Future Work](#future_work)**<br>
**[References](#references)**<br>

## Getting Started
Developers can [clone](https://github.com/denizstav/FlickrImage.git) or [download](https://github.com/denizstav/FlickrImage/archive/master.zip) the project for examining the source code:

### Prerequisites
1) Latest stable version of Xcode. 
2) Swift 4 (or above)

## Decisions
In this project, the decisions below are made: 
- Clean Architecture and Clean Swift Templates are used.
- URLCache is used as an image caching solution
- Constants: Rather than creating a constant class, constants are defined in the class with ```swift fileprivate``` keyword. 
- Structs mostly used as model objects. 
- Mainstoryboard: Rather than creating a new storyboard, Mainstoryboard is used since this is a one page app. 
- Flickr colors and logos are used.

## Architecture
![VIP-Cycle](https://user-images.githubusercontent.com/42461474/64063750-e113a600-cbf8-11e9-822e-ffa0b9543929.png)

Here:
- **ListPhotosViewController** invokes **ListPhotosInteractor** through **ListPhotosBusinessLogic**. **ListPhotosBusinessLogic** is an interface which is implemented by the **ListPhotosInteractor.** 
- Upon finishing data processing, **ListPhotosInteractor** passes data to **ListPhotosPresentationLogic**. Again the **ListPhotosPresentationLogic** is an interface which is implemented by the **ListPhotosPresenter**. 
- Finally the **ListPhotosPresenter** passes the data in the form of **ViewModel** to **ListPhotosDisplayLogic**. The **ListPhotosViewController** implements **ListPhotosDisplayLogic**.

## Image Caching Solution
### URLCache
The [URLCache](https://developer.apple.com/documentation/foundation/urlcache) class implements the caching of responses to URL load requests by mapping NSURLRequest objects to CachedURLResponse objects. It provides a composite in-memory and on-disk cache, and lets you manipulate the sizes of both the in-memory and on-disk portions.

UrlCache gives us the ability to cache responses made to URL requests. We can use this cache to store all response data. It is not limited to images. For this project, we only use it for images.

```swift
fileprivate let errorStatusCode: Int = 500
fileprivate let minErrorStatusCode: Int = 300

public extension UIImageView {

    func loadImage(fromURL url: String) {
        guard let imageURL = URL(string: url) else {
            return
        }
        let cache =  URLCache.shared
        let request = URLRequest(url: imageURL)
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    guard let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? errorStatusCode) <       minErrorStatusCode, let image = UIImage(data: data) else {
                        return
                    }
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }).resume()
            }
        }
    }
}
```
1) Firstly we create a URL from the string that is passed into our function. If the URL fails to instantiate we return and do not perform any further operations.
2) We create our cache from the shared URLCache. This is the default cache which is suitable for most uses cases. Then next we create a URLRequest from the URL.
3) We make use of a userInitiated queue to do the work. This is done so that we do not block the main thread and block our apps UI as we load the image. First we check if the image we are trying to request is in our cache already.
4) If it is in the cache we display the image. 
5) When the image can not be found in the cache we then go ahead and make a request for the image using URLSession. We check that we have data and a response. We also validate that the response is a succeeded before we perform any work. Finally we create the cachedData from the response and the data and store it into the cache. Then we display the image.

## Future Work
- Dependency Injection
- Localization
- Network Error Handling Mechanism 
- Proper design and animations.

## References
- https://clean-swift.com/clean-swift-ios-architecture/
- https://www.flickr.com
- https://developer.apple.com/documentation/foundation/urlcache
