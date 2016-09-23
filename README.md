# . . : : beacon-bacon-ios : : . .

Demo app for https://github.com/nosuchagency/beacon-bacon

## GET STARTED

1. Request an API Key from https://beaconbacon.nosuchagency.com <br>(Read how to get setup Places / Points of Interest / Beacons etc. [here](https://github.com/nosuchagency/beacon-bacon))
2. BBConfig.h -> BB_API_KEY -> Insert your API Key

You are now able to use the lib. 
You can either use your own integration with API using element from the [./core](https://github.com/mustachedk/beacon-bacon-ios/tree/master/beaconbacon/beacon-bacon-lib-ios/core) folder.
You can also use the default UI library [./wayfinding](https://github.com/mustachedk/beacon-bacon-ios/tree/master/beaconbacon/beacon-bacon-lib-ios/wayfinding)

## USING WAYFINDING

You can see an example in [./ViewController.m](https://github.com/mustachedk/beacon-bacon-ios/blob/master/beaconbacon/ViewController.m)

####Start using a specific Place:
```Objective-C
[[BBConfig sharedConfig] setPlaceIdentifierInBackground:@"YOUR_PLACE_ID"];
```

####Configure the UI:
```Objective-C
[BBConfig sharedConfig].customColor = [UIColor magentaColor];
[BBConfig sharedConfig].regularFont = [UIFont fontWithName:@"Avenir-Regular" size:16];
[BBConfig sharedConfig].lightFont   = [UIFont fontWithName:@"Avenir-Light" size:16];
```

####Initiate map without wayfinding:
```Objective-C
BBLibraryMapViewController *mapViewController = [[BBLibraryMapViewController alloc] initWithNibName:@"BBLibraryMapViewController" bundle:nil];
[self presentViewController:mapViewController animated:true completion:nil];
```

####Find a subject (IMS)
```Objective-C
// Create a request (JSON body) - The API will return a subject
// This example is for a IMS subject - but can be anything you want the API to look for

NSMutableDictionary *requestDict = [NSMutableDictionary new];
[requestDict setObject:@"IMS" forKey:@"find_identifier"];

NSMutableDictionary *data = [NSMutableDictionary new];
[data setObject:@"FAUST_IDENTIFIER" forKey:@"Faust"];
[requestDict setObject:data forKey:@"data"];

[[BBDataManager sharedInstance] requestFindASubject:requestDict withCompletion:^(BBFoundSubject *result, NSError *error) {
   if (error == nil) {
       if (result != nil && [result isSubjectFound]) {
           // Material is found for way finding
           result.subject_name     = @"NAME_TO_DISPLAY";
           result.subject_subtitle = @"SUBTITLE_TO_DISPLAY";
           result.subject_image    = [UIImage imageNamed:@"menu-library-map-icon"]; // Or any other icon you want it to display, eg. a book/video/tape etc.
           
           // 1. Store the BBFoundSubject 'result' for when you need to 'Initiale map with wayfinding'
           // 2. Optional: display/enable a button for wayfinding
       } else {
           // No material found for way finding
       }
   } else {
       // An error occurred
   }
}];
```
####Initiate map with wayfinding:
```Objective-C
BBLibraryMapViewController *mapViewController = [[BBLibraryMapViewController alloc] initWithNibName:@"BBLibraryMapViewController" bundle:nil];
mapViewController.foundSubject = theFoundSubject; // Stored BBFoundSubject 'result' from BBDataManager.requestFindASubject:

[self presentViewController:mapViewController animated:true completion:nil];
```
