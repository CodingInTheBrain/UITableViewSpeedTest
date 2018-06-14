//
//  ImgCacheManage.m
//  UITableViewSpeedTest
//
//  Created by surio on 2018/6/13.
//  Copyright © 2018年 surio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImgCacheManage.h"
#import "Encryption.h"

#define DirectoryName   @"localImg"

typedef void(^Finish)(UIImage *img);

static ImgCacheManage *manage;

@interface ImgCacheManage () <NSCacheDelegate>
{
    NSCache *_imgCache;
    
    NSFileManager *_fileManager;
    
    dispatch_semaphore_t _semaphore;
    
    dispatch_queue_t _imgQueue;
    

}
@end

@implementation ImgCacheManage

+ (nonnull instancetype)shareManage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [self new];
    });
    return manage;
}

- (nonnull instancetype)init {
    if (self = [super init]) {
        _imgCache = [[NSCache alloc] init];
        _imgCache.totalCostLimit    =   100.0f * 1024.0f *1024.0f;  //缓存大小限制
        _imgCache.countLimit        =   200;                        //缓存数量限制
        
        _imgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        _imgCache.delegate = self;
        
        dispatch_async(_imgQueue, ^{
            _fileManager = [NSFileManager new];
        });
    
        _semaphore = dispatch_semaphore_create(4);                  //并发控制
    }
    return self;
}

- (UIImage *)cacheForUrl:(NSString *)imgUrl {
 
    NSString *md5   = [Encryption md5EncryptWithString:imgUrl];
    UIImage *img    = [_imgCache objectForKey:md5];
    return img;
}

- (void)cacheWithObject:(id)objc With:(NSString *)imgUrl cost:(NSUInteger)cost
{
    NSString *md5   = [Encryption md5EncryptWithString:imgUrl];
    [_imgCache setObject:objc forKey:md5 cost:cost];
//    NSLog(@"缓存了 %@",[_imgCache objectForKey:md5]);
}

- (BOOL)isExistsDiskImgWith:(NSString *)imgUrl {
    NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *directoryPath = [localPath stringByAppendingPathComponent:DirectoryName];
    NSString *md5 = [Encryption md5EncryptWithString:imgUrl];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:md5];
    BOOL exists     = [[NSFileManager defaultManager]  fileExistsAtPath:filePath];
    
    return exists;
}

- (void)diskForUrl:(NSString *)imgUrl complete:(completeBlock)complete {
    
    dispatch_async(_imgQueue, ^{
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);

        @autoreleasepool {
            NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *directoryPath = [localPath stringByAppendingPathComponent:DirectoryName];
            NSString *md5 = [Encryption md5EncryptWithString:imgUrl];
            NSString *filePath = [directoryPath stringByAppendingPathComponent:md5];
            UIImage *img;
            BOOL exists     = [[NSFileManager defaultManager]  fileExistsAtPath:filePath];

            if (exists) {
                NSData *data = [NSData dataWithContentsOfFile:filePath];
                img = [UIImage imageWithData:data];
            }
            
            if (!exists) {
                //模拟网络请求
                NSData *data = [NSData dataWithContentsOfFile:imgUrl];
                img = [UIImage imageWithData:data];
                if (img) {
            
                    BOOL isExsitsDirectory;
                    isExsitsDirectory = [_fileManager isExecutableFileAtPath:directoryPath];
                    if (!isExsitsDirectory) {
                        BOOL isSuccessCreateDirectory = [_fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:NULL error:NULL];
                        if (!isSuccessCreateDirectory) {
                            NSLog(@"文件夹创建失败");
                        }
                    }
                    BOOL isSuccessWriteFile = [data writeToFile:filePath atomically:YES];
                    if (!isSuccessWriteFile) {
                        NSLog(@"图片写入失败");
                    }
                    if (complete) {
                        complete(img);
                    }
                }
            }
            if (complete) {
                complete(img);
            }
            
        }
        dispatch_semaphore_signal(_semaphore);

    });
    
}

- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    
    NSLog(@"清除了 %@",obj);
}


@end
