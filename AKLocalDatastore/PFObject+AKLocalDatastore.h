//
//  PFObject+AKLocalDatastore.h
//  AKLocalDatastore
//
//  Created by Alex Koren on 2/11/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import <Parse/Parse.h>

typedef enum retrievalType {
    AKFileDataRetrievalTypeCache,
    AKFileDataRetrievalTypeLocal,
    AKFileDataRetrievalTypeRemote
} AKFileDataRetrievalType;

@interface PFObject (AKLocalDatastore)

@property (nonatomic, strong) NSString *fileColumnName;

- (void)getFileDataWithBlock:(void(^)(NSData* fileData, AKFileDataRetrievalType retrievalType))block;

@end
