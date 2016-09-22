# . . : : beacon-bacon-ios : : . .

Demo app for https://github.com/nosuchagency/beacon-bacon

## GET STARTED

1. Request an API Key from https://beaconbacon.nosuchagency.com 
   (Read how to get setup Places/Points of Interest/Beacons etc. at [here](https://github.com/nosuchagency/beacon-bacon))
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

####Initiate map with wayfinding:
```Objective-C
 [[BBDataManager sharedInstance] requestFindMaterial:materialDict withCompletion:^(BBFindPOI *result, NSError *error) {
        if (error == nil) {
            if (result != nil && [result isMaterialFound]) {
                // Material is found for way finding
                mapViewController = [[BBLibraryMapViewController alloc] initWithNibName:@"BBLibraryMapViewController" bundle:nil];
                
                NSMutableDictionary *materialDict = [NSMutableDictionary new];
                [materialDict setObject:@"IMS" forKey:@"find_identifier"];
                NSMutableDictionary *data = [NSMutableDictionary new];
                
                [data setObject:@"En mand der hedder Ove" forKey:@"title"];
                [data setObject:@"SK" forKey:@"shelfmark"];
                [materialDict setObject:data forKey:@"data"];
                
                mapViewController.theFoundPOI = result;
                mapViewController.materialDict = [materialDict copy];
                mapViewController.materialImage = [UIImage imageNamed:@"menu-library-map-icon"];
                [self presentViewController:mapViewController animated:true completion:nil];
            } else {
                // No material found for way finding
            }
        } else {
            // An error occurred
        }
    }];
```
