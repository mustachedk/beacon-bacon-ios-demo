//
// BBDataManager.h
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

#import <Foundation/Foundation.h>
#import "BBPOISection.h"
#import "BBPOI.h"
#import "BBAPIClient.h"
#import "BBPOIMenuItem.h"
#import "BBPlace.h"
#import "BBFoundSubject.h"
#import "AFNetworking.h"

typedef void (^CompletionBlock)(id result, NSError *error);

@interface BBDataManager : NSObject

+ (BBDataManager *)sharedInstance;

- (void) setCurrentPlaceFromLibraryIdInBackground:(NSString *)libraryID;

- (void) requestPOIMenuItemsWithCompletion:(CompletionBlock)completionBlock;

- (void) requestSelectedPOIMenuItemsWithCompletion:(CompletionBlock)completionBlock;

- (void) requestCurrentPlaceSetupWithCompletion:(CompletionBlock)completionBlock;

- (void) requestFindASubject:(NSDictionary *)requestDict withCompletion:(CompletionBlock)completionBlock;

@end
