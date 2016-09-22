//
// BBDataManager.m
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

#import "BBDataManager.h"

@interface BBDataManager()

@property (nonatomic, strong) NSArray *cachedMenuItems;
@property (nonatomic, strong) BBPlace *cachedCurrentPlace;

@end


@implementation BBDataManager

+ (BBDataManager *)sharedInstance {
    
    static BBDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BBDataManager alloc] init];
        
    });
    return sharedInstance;
}

- (NSError *) unsupportedPlaceError {
    NSDictionary *errorDictionary = @{ NSLocalizedDescriptionKey : @"Unsupported Place", NSUnderlyingErrorKey : @(404) };
    return [[NSError alloc] initWithDomain:@"beaconbacon.nosuchagency.com" code:404 userInfo:errorDictionary];

}

- (void) clearAllChacedData {
    self.cachedMenuItems = nil;
    self.cachedCurrentPlace = nil;
}

- (void) setCurrentPlaceFromLibraryIdInBackground:(NSString *)libraryID {
    
    [[BBAPIClient sharedClient] GET:@"place/" parameters:nil progress:nil success:^(NSURLSessionDataTask __unused *task, id JSON) {
        
        NSError *error;
        NSDictionary *attributes = [NSJSONSerialization JSONObjectWithData:JSON options:kNilOptions error:&error];
        if (error) {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:BB_STORE_KEY_CURRENT_PLACE_ID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [BBConfig sharedConfig].currentPlaceId = nil;
            [self clearAllChacedData];
            return;
        }
        
        NSArray *places = attributes[@"data"];
        for (NSDictionary *placeAttributes in places) {
            if ([placeAttributes[@"identifier"] isEqualToString:libraryID]) {
                NSString *currentPlaceId = [NSString stringWithFormat:@"%ld", (unsigned long)[[placeAttributes valueForKeyPath:@"id"] integerValue]];
                [[NSUserDefaults standardUserDefaults] setObject:currentPlaceId forKey:BB_STORE_KEY_CURRENT_PLACE_ID];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [BBConfig sharedConfig].currentPlaceId = currentPlaceId;
                [self clearAllChacedData];
                return;
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:BB_STORE_KEY_CURRENT_PLACE_ID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [BBConfig sharedConfig].currentPlaceId = nil;
        [self clearAllChacedData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:BB_STORE_KEY_CURRENT_PLACE_ID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [BBConfig sharedConfig].currentPlaceId = nil;
        [self clearAllChacedData];
        
    }];
    
}


- (void) requestPOIMenuItemsWithCompletion:(CompletionBlock)completionBlock {
    
    if ([BBConfig sharedConfig].currentPlaceId == nil) {
        completionBlock(nil, [self unsupportedPlaceError]);
        return;
    }
    
    if (self.cachedMenuItems == nil) {
        
        NSString *route = [NSString stringWithFormat:@"place/%@/menu", [BBConfig sharedConfig].currentPlaceId];
        [[BBAPIClient sharedClient] GET:route parameters:nil progress:nil success:^(NSURLSessionDataTask __unused *task, id JSON) {

            NSError *error;
            NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:JSON options:kNilOptions error:&error];
            if (error) {
                completionBlock(nil, error);
                return;
            }
            NSMutableArray *menu = [[NSMutableArray alloc] initWithCapacity:jsonData.count];
            
            for (NSDictionary *attributes in jsonData) {
                BBPOIMenuItem *menuItem = [[BBPOIMenuItem alloc] initWithAttributes:attributes];
                [menu addObject:menuItem];
            }
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            
            self.cachedMenuItems = [menu sortedArrayUsingDescriptors:sortDescriptors];

            completionBlock(self.cachedMenuItems, nil);

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            completionBlock(nil, error);

        }];
    
    } else {
        // Return Cache
        completionBlock(self.cachedMenuItems, nil);
    }
}

- (void) requestSelectedPOIMenuItemsWithCompletion:(CompletionBlock)completionBlock {
    
    if ([BBConfig sharedConfig].currentPlaceId == nil) {
        completionBlock(nil, [self unsupportedPlaceError]);
        return;
    }
    
    if (self.cachedMenuItems == nil) {
        
        completionBlock(@[], nil);
    } else {
        
        NSMutableArray *selectedItems = [NSMutableArray new];
        for (BBPOIMenuItem *item in self.cachedMenuItems) {
            if (item.isPOIMenuItem) {
                if (item.poi.selected) {
                    [selectedItems addObject:item];
                }
            }
        }
        completionBlock(selectedItems, nil);
    }
}

- (void) requestCurrentPlaceSetupWithCompletion:(CompletionBlock)completionBlock {
    
    if ([BBConfig sharedConfig].currentPlaceId == nil) {
        completionBlock(nil, [self unsupportedPlaceError]);
        return;
    }
    
    if (self.cachedCurrentPlace == nil || self.cachedCurrentPlace.place_id != [[BBConfig sharedConfig].currentPlaceId integerValue]) {

        NSDictionary *params = @{@"embed" : @"floors.locations.beacon"};
        NSString *route = [NSString stringWithFormat:@"place/%@/", [BBConfig sharedConfig].currentPlaceId];
        [[BBAPIClient sharedClient] GET:route parameters:params progress:nil success:^(NSURLSessionDataTask __unused *task, id JSON) {
            
            NSError *error;
            NSDictionary *attributes = [NSJSONSerialization JSONObjectWithData:JSON options:kNilOptions error:&error];
            if (error) {
                completionBlock(nil, error);
                return;
            }
            self.cachedCurrentPlace = [[BBPlace alloc] initWithAttributes:attributes];
            
            completionBlock(self.cachedCurrentPlace, nil);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            completionBlock(nil, error);
            
        }];
        
    } else {
        completionBlock(self.cachedCurrentPlace, nil);

    }
    
}

- (void) requestFindMaterial:(NSDictionary *)material withCompletion:(CompletionBlock)completionBlock {
    
    if ([BBConfig sharedConfig].currentPlaceId == nil) {
        completionBlock(nil, [self unsupportedPlaceError]);
        return;
    }
    NSString *route = [NSString stringWithFormat:@"%@place/%@/find", BB_BASE_URL, [BBConfig sharedConfig].currentPlaceId];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:material options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = @"";
    if (!jsonData) {
        completionBlock(nil, error);
        return;
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:route parameters:nil error:nil];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:[NSString stringWithFormat:@"Bearer %@", BB_API_KEY] forHTTPHeaderField:@"Authorization"];

    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error == nil) {
            BBFindPOI *findPOI = [[BBFindPOI alloc] initWithAttributes:responseObject];
            completionBlock(findPOI, nil);
        } else {
            completionBlock(nil, error);
        }
    }] resume];
    

}

- (void) request_TEMPLATE_WithCompletion:(CompletionBlock)completionBlock {
    
}

@end
