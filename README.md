# beacon-bacon-ios

Demo app for https://github.com/nosuchagency/beacon-bacon

:: GET STARTED ::

1. Request an API Key from https://beaconbacon.nosuchagency.com (Don't you have a user? - Read how to get setup Places/Points of Interest/Beacons etc. at https://github.com/nosuchagency/beacon-bacon)
2. BBConfig -> BB_API_KEY -> Insert your API Key

You are now able to use the lib. 
You can either use your own integration with API using element from the ./core folder.
You can also use the default UI library ./wayfinding

:: USING WAYFINDING ::

You can see an example in ./ViewController.m

Start using a specific Place:
[[BBConfig sharedConfig] setPlaceIdentifierInBackground:@"YOUR_PLACE_ID"];

Configure the UI:
[BBConfig sharedConfig].customColor = [UIColor magentaColor];
[BBConfig sharedConfig].regularFont = [UIFont fontWithName:@"Avenir-Regular" size:16];
[BBConfig sharedConfig].lightFont   = [UIFont fontWithName:@"Avenir-Light" size:16];

Initiate map without wayfinding:
BBLibraryMapViewController *mapViewController = [[BBLibraryMapViewController alloc] initWithNibName:@"BBLibraryMapViewController" bundle:nil];
[self presentViewController:mapViewController animated:true completion:nil];

Initiate map with wayfinding:
