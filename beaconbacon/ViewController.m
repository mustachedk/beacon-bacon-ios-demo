//
// ViewController.m
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

#import "ViewController.h"
#import "BBConfig.h"
#import "BBLibraryMapViewController.h"

@implementation ViewController {
    BBLibraryMapViewController *mapViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)noStyleAction:(id)sender {
    [BBConfig sharedConfig].customColor = nil;
    [BBConfig sharedConfig].regularFont = nil;
    [BBConfig sharedConfig].lightFont   = nil;
}

- (IBAction)style1Action:(id)sender {
    [BBConfig sharedConfig].customColor = [UIColor magentaColor];
    [BBConfig sharedConfig].regularFont = [UIFont fontWithName:@"Avenir-Regular" size:16];
    [BBConfig sharedConfig].lightFont   = [UIFont fontWithName:@"Avenir-Light" size:16];
}

- (IBAction)style2Action:(id)sender {
    [BBConfig sharedConfig].customColor = [UIColor orangeColor];
    [BBConfig sharedConfig].regularFont = [UIFont fontWithName:@"Menlo-Bold" size:16];
    [BBConfig sharedConfig].lightFont   = [UIFont fontWithName:@"Menlo-Regular" size:16];
}

- (IBAction)placeKBHaction:(id)sender {
    [[BBConfig sharedConfig] setPlaceIdentifierInBackground:@"koebenhavnsbib"];
}

- (IBAction)placeMustacheAction:(id)sender {
    [[BBConfig sharedConfig] setPlaceIdentifierInBackground:@"koldingbib"];
}

- (IBAction)placeUnsupportedAction:(id)sender {
    [[BBConfig sharedConfig] setPlaceIdentifierInBackground:@"apple-campus-2"];
}

- (IBAction)mapAction:(id)sender {
    mapViewController = [[BBLibraryMapViewController alloc] initWithNibName:@"BBLibraryMapViewController" bundle:nil];
    [self presentViewController:mapViewController animated:true completion:nil];
}

- (IBAction)mapWayfindingAction:(id)sender {
    
    BBIMSRequstSubject *requstObject = [[BBIMSRequstSubject alloc] initWithFaustId:@"50631494"];

    [[BBDataManager sharedInstance] requestFindIMSSubject:requstObject withCompletion:^(BBFoundSubject *result, NSError *error) {
        if (error == nil) {
            if (result != nil && [result isSubjectFound]) {
                // Material is found for way finding
                mapViewController = [[BBLibraryMapViewController alloc] initWithNibName:@"BBLibraryMapViewController" bundle:nil];
                
                result.subject_name     = @"En mand der hedder Ove";
                result.subject_subtitle = @"SK";
                result.subject_image    = [UIImage imageNamed:@"menu-library-map-icon"];
                
                mapViewController.foundSubject = result;
                
                [self presentViewController:mapViewController animated:true completion:nil];
            } else {
                // No material found for way finding
            }
        } else {
            // An error occurred
        }
    }];
    
}

@end
