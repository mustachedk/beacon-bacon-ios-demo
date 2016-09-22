//
// BBLibraryMapViewController.h
//
// Copyright (c) 2016 Mustache ApS
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BBTrilateration.h"
#import "BBBeacon.h"
#import "BBLibraryMapPOIViewController.h"
#import "BBDataManager.h"
#import "BBFloor.h"
#import "AFNetworking.h"
#import "BBMyPositionView.h"
#import <QuartzCore/QuartzCore.h>
#import "BBPOIMapView.h"

@interface BBLibraryMapViewController : UIViewController <CLLocationManagerDelegate>

// Wayfinding Item
@property (nonatomic, strong) BBFoundSubject *foundSubject;

// Custom Navigation/Top Bar
@property (weak, nonatomic) IBOutlet UIView *fakeNavigationBar;
@property (weak, nonatomic) IBOutlet UIView *topLineView;

@property (weak, nonatomic) IBOutlet UIButton *navBarNextButton;
@property (weak, nonatomic) IBOutlet UIButton *navBarPreviousButton;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
- (IBAction)closeButtonAction:(id)sender;


// Default Top Bar
@property (weak, nonatomic) IBOutlet UIView *defaultTopBar;
@property (weak, nonatomic) IBOutlet UILabel *navBarTitleLabel;


// Navigate To Material Top Bar
@property (weak, nonatomic) IBOutlet UIView *materialTopBar;
@property (weak, nonatomic) IBOutlet UIImageView *materialTopImageView;
@property (weak, nonatomic) IBOutlet UILabel *materialTopTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *materialTopSubtitleLabel;


// Bottom Right Cornor Views

@property (weak, nonatomic) IBOutlet UIButton *myLocationButton;

@property (weak, nonatomic) IBOutlet UIButton *pointsOfInterestButton;

// Other Views
@property (weak, nonatomic) IBOutlet UIScrollView *mapScrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (strong, nonatomic) CLLocationManager *locationManager;


// My Position Pop Down
@property (weak, nonatomic) IBOutlet UIView *myPositionPopDownView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myPositionPopDownTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *myPositionPopDownLabel;
@property (weak, nonatomic) IBOutlet UIButton *myPositionPopDownButton;

// Material Position Pop Down
@property (weak, nonatomic) IBOutlet UIView *materialPopDownView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *materialPopDownTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *materialPopDownLabel;
@property (weak, nonatomic) IBOutlet UILabel *materialPopDownText;
@property (weak, nonatomic) IBOutlet UIButton *materialPopDownButton;

- (IBAction)navBarNextAction:(id)sender;
- (IBAction)navBarPreviousAction:(id)sender;

- (IBAction)pointsOfInterestAction:(id)sender;

- (IBAction)myLocationAction:(id)sender;

- (IBAction)myPositionPopDownButtonAction:(id)sender;
- (IBAction)materialPopDownButtonAction:(id)sender;

@end
