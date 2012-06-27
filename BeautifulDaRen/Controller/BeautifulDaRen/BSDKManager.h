//
//  SinaSDKManager.h
//  AllInOne
//
//  Created by jerry.li on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ControllerConstants.h"
#import "BSDKEngine.h"
#import "BaseManager.h"

@interface BSDKManager : BaseManager <BSDKEngineDelegate>

@property (strong, nonatomic) BSDKEngine *BSDKWeiboEngine;

+ (BSDKManager*) sharedManager;

- (BOOL)isLogin;

- (void)setRootviewController:(UIViewController*)rootViewController;

- (void)signUpWithUsername:(NSString*)username
                  password:(NSString*)password
                     email:(NSString*)email
                      city:(NSString*)city
           andDoneCallback:(processDoneWithDictBlock)doneBlock;

- (void)loginWithUsername:(NSString*)username
                 password:(NSString*)password
          andDoneCallback:(processDoneWithDictBlock)doneBlock;

- (void)logoutWithDoneCallback:(processDoneWithDictBlock)doneBlock;

- (void)changePasswordByUsername:(NSString*)username
                     oldPassword:(NSString*)oldPassword
                   toNewPassword:(NSString*)newpassword
                 andDoneCallback:(processDoneWithDictBlock)doneBlock;

#pragma mark user releated API
- (void)getUserInforByUserId:(NSString*)userId
             andDoneCallback:(processDoneWithDictBlock)doneBlock;

- (void)searchUsersByUsername:(NSString*)username
                     pageSize:(NSInteger)pageSize 
                    pageIndex:(NSInteger)pageIndex 
              andDoneCallback:(processDoneWithDictBlock)doneBlock;


#pragma mark Weibo releated API

// Send a Weibo, to which you can attach an image.
- (void)sendWeiboWithText:(NSString *)text 
                    image:(UIImage *)image 
                     shop:(NSString*)shop
                    brand:(NSString*)branch
                    price:(NSInteger)price
                 category:(NSString*)category
              poslatitude:(float)latitude
             posLongitude:(float)longitude
             doneCallback:(processDoneWithDictBlock)callback;

// repost a weibo
- (void)rePostWeiboById:(NSString*)blogId
               WithText:(NSString *)text 
        andDoneCallback:(processDoneWithDictBlock)callback;

// If username is specified, then it will retrieve the weibos which is sent by this user, or it will retrieve the neweset weibos.
- (void)getWeiboListByUsername:(NSString*)username
                      pageSize:(NSInteger)pageSize 
                     pageIndex:(NSInteger)pageIndex 
               andDoneCallback:(processDoneWithDictBlock)callback;

- (void)getWeiboListByUserId:(NSString*)userId
                    pageSize:(NSInteger)pageSize 
                   pageIndex:(NSInteger)pageIndex 
             andDoneCallback:(processDoneWithDictBlock)callback;

// get the users which you are followed's weibo
- (void)getFriendsWeiboListByUsername:(NSString*)username
                      pageSize:(NSInteger)pageSize 
                     pageIndex:(NSInteger)pageIndex 
               andDoneCallback:(processDoneWithDictBlock)callback;

- (void)searchWeiboByKeyword:(NSString*)key
                      pageSize:(NSInteger)pageSize 
                     pageIndex:(NSInteger)pageIndex 
               andDoneCallback:(processDoneWithDictBlock)callback;

- (void)getWeiboListByClassId:(NSString*)classId
                    pageSize:(NSInteger)pageSize 
                   pageIndex:(NSInteger)pageIndex 
             andDoneCallback:(processDoneWithDictBlock)callback;

- (void)getAtWeiboListByUserId:(NSString*)userId
                     pageSize:(NSInteger)pageSize 
                    pageIndex:(NSInteger)pageIndex 
              andDoneCallback:(processDoneWithDictBlock)callback;

- (void)getWeiboClassesWithDoneCallback:(processDoneWithDictBlock)callback;

- (void)getWeiboById:(NSString*)classId
     andDoneCallback:(processDoneWithDictBlock)callback;

#pragma mark Social related API
- (void)followUser:(NSInteger)userId
   andDoneCallback:(processDoneWithDictBlock)callback;

- (void)unFollowUser:(NSInteger)userId
   andDoneCallback:(processDoneWithDictBlock)callback;

- (void)getFollowList:(NSString*)userId
             pageSize:(NSInteger)pageSize 
            pageIndex:(NSInteger)pageIndex 
     andDoneCallback:(processDoneWithDictBlock)callback;

- (void)getFollowerList:(NSInteger)userId
               pageSize:(NSInteger)pageSize 
              pageIndex:(NSInteger)pageIndex 
        andDoneCallback:(processDoneWithDictBlock)callback;

- (void)sendComment:(NSString*)comment
            toWeibo:(NSString*)blogId
     andDoneCallback:(processDoneWithDictBlock)callback;

- (void)addFavourateForWeibo:(NSString*)blogId
    andDoneCallback:(processDoneWithDictBlock)callback;

- (void)removeFavourateForWeibo:(NSString*)blogId
                andDoneCallback:(processDoneWithDictBlock)callback;

- (void)getCommentListOfWeibo:(NSString*)blogId
                     pageSize:(NSInteger)pageSize 
                    pageIndex:(NSInteger)pageIndex 
    andDoneCallback:(processDoneWithDictBlock)callback;

- (void)getCommentListOfUser:(NSString*)userId
                     pageSize:(NSInteger)pageSize 
                    pageIndex:(NSInteger)pageIndex 
              andDoneCallback:(processDoneWithDictBlock)callback;

@end
