//
//  CommonCrytoFunctions.h
//  AVPlayer Progressive Download
//
//  Created by Mohammad Bharmal on 6/10/15.
//  Copyright (c) 2015 Mohammad Bharmal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
@interface CommonCrytoFunctions : NSObject{
    char key[16];
    char iv[16];
    CCCryptorRef cryptorRef;

}
-(id)initWithKey:(NSString*)key andIV:(NSString*)iv;
-(id)initWith16ByteKey:(NSString*)_key andIV:(NSString*)_iv;
-(NSData*)decrypt:(NSData*)data;
-(NSString*)decryptString:(NSString*)string;
-(NSData*)final;
@end
