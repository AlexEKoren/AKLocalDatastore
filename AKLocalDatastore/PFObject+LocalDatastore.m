//
//  PFObject+LocalDatastore.m
//  AKLocalDatastore
//
//  Created by Alex Koren on 2/11/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import "PFObject+LocalDatastore.h"
#import <objc/runtime.h>

@interface PFObject (LocalDatastorePrivate)

@property (nonatomic, strong) NSData *cachedFileData;

@end

@implementation PFObject (LocalDatastore)

- (void)getFileDataWithBlock:(void (^)(NSData *fileData, AKFileDataRetrievalType retrievalType))block {
    //check for cached data
    if (!!self.cachedFileData) {
        //if it's there, return it
        block(self.cachedFileData, AKFileDataRetrievalTypeCache);
        return;
    }
    
    NSData *fileData = [self retrieveLocalFileData];
    
    if (!fileData) {
        //File is not found in documents directory
        //Check to see if a column name for the file has been specified
        if (!self.fileColumnName) {
            [NSException raise:@"No File Column Name Specified" format:@"You have to supply the column name where the file is stored for PFObject %@", self];
        }
        
        //Go fetch the file
        PFFile *file = self[self.fileColumnName];
        [file getDataInBackgroundWithBlock:^(NSData *remoteData, NSError *error) {
            //save to cache
            self.cachedFileData = remoteData;
            //save the file to the documents directory
            [self saveFileData:remoteData];
            //send it back in the callback block
            block(remoteData, AKFileDataRetrievalTypeRemote);
        }];
        return;
    }
    
    //save file data to cache
    self.cachedFileData = fileData;
    
    //send it back in the callback if it was found in the documents directory
    block(fileData, AKFileDataRetrievalTypeLocal);
}

//Gets the file data from the documents directory
- (NSData*)retrieveLocalFileData {
    NSString *fileUrl = [NSString stringWithFormat:@"%@/%@.data", [self savePath], self.objectId];
    return [[NSData alloc]initWithContentsOfURL:[NSURL fileURLWithPath:fileUrl]];
}

//Saves the file data to the documents directory
- (void)saveFileData:(NSData*)fileData {
    NSString *fileUrl = [NSString stringWithFormat:@"%@/%@.data", [self savePath], self.objectId];
    [fileData writeToFile:fileUrl atomically:YES];
}

//Creates a save path at DocumentsDirectory/AKLocalDatastore
- (NSString*)savePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths.firstObject;
    NSString *folder = [NSString stringWithFormat:@"%@/AKLocalDatastore", documentsDirectory];
    //if the folder doesn't exist, we have to create one
    if (![[NSFileManager defaultManager] fileExistsAtPath:folder])
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:NO attributes:nil error:nil];
    return folder;
}

#pragma mark - Associated Objects

- (void)setCachedFileData:(NSData *)cachedFileData {
    objc_setAssociatedObject(self, @selector(cachedFileData), cachedFileData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSData*)cachedFileData {
    return (NSData*)objc_getAssociatedObject(self, @selector(cachedFileData));
}

- (void)setFileColumnName:(NSString *)fileColumnName {
    objc_setAssociatedObject(self, @selector(fileColumnName), fileColumnName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString*)fileColumnName {
    return (NSString*)objc_getAssociatedObject(self, @selector(fileColumnName));
}

@end
