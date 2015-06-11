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
-(NSData*)decrypt:(NSData*)data;
-(NSData*)final;
@end
