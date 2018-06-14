//
//  Encryption.h
//  NSCachTest
//
//  Created by surio on 2018/6/5.
//  Copyright © 2018年 surio. All rights reserved.
//

#import <Foundation/Foundation.h>
//秘钥
@interface Encryption : NSObject

/**
 MD5加密

 @param string 需要加密的字符串
 @return 加密过的MD5字符串
 */
+ (NSString *)md5EncryptWithString:(NSString *)string;

@end
