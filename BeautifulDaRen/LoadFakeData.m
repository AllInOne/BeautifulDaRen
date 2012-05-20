//
//  LoadFakeData.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/19/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "LoadFakeData.h"
#import "DataManager.h"
#import "DataConstants.h"

static LoadFakeData * sharedInstance;

@interface LoadFakeData()

- (void) loadLocalIdentity;
- (void) loadFriends;
- (void) loadWeibos;
- (void) loadComments;
- (void) loadForwards;

@end

@implementation LoadFakeData

+(LoadFakeData*) sharedLoadManager
{
    @synchronized([LoadFakeData class])
    {
        if(!sharedInstance)
        {
            sharedInstance = [[LoadFakeData alloc] init];
        }
    }
    return sharedInstance;
}

-(void) load
{
    [self loadLocalIdentity];
    [self loadFriends];
    [self loadWeibos];
    [self loadComments];
    [self loadFriends];
}

- (void) loadLocalIdentity
{
    NSString * fakeLocalIdentityId = @"LOCAL_IDENTITY_001";
    [[NSUserDefaults standardUserDefaults] setValue:fakeLocalIdentityId forKey:BEAUTIFUL_DAREN_USER_IDENTITY_ID];
    NSDictionary * userIdentityDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       fakeLocalIdentityId, USERIDENTITY_UNIQUE_ID,
                                       @"user name", USERIDENTITY_DISPLAY_NAME,
                                       @"12", USERIDENTITY_LEVEL,
                                       @"成都", USERIDENTITY_LOCAL_CITY,
                                       @"9", USERIDENTITY_FOLLOW_COUNT,
                                       @"10", USERIDENTITY_FANS_COUNT,
                                       @"11", USERIDENTITY_BUYED_COUNT,
                                       @"12", USERIDENTITY_COLLECTION_COUNT,
                                       @"13", USERIDENTITY_TOPIC_COUNT,
                                       @"14", USERIDENTITY_BLACK_LIST_COUNT,
                                       @"0", USERIDENTITY_IS_MALE,
                                       @"I am super.", USERIDENTITY_PERSONAL_BRIEF,
                                       @"成都，天府软件园", USERIDENTITY_DETAILED_ADDRESS,
                                       nil];
    [[DataManager sharedManager] saveLocalIdentityWithDictionary:userIdentityDict finishBlock:^(NSError *error) {
        NSLog(@"Save local identity successful");
    }];
}

- (void) loadFriends
{
    
}
- (void) loadWeibos
{
    
}
- (void) loadComments
{
    //    NSArray * userNames = [NSArray arrayWithObjects:@"阿丘",@"你不在",
    //                             @"多余的人",@"一丝雪",@"思密达",@"叶子",
    //                             @"窗外的雨",@"丘比特",@"阿丘",@"一丝雪",@"你不在",@"窗外的雨", @"一丝雪", nil];
    //    NSArray * ages = [NSArray arrayWithObjects:@"1分钟前",@"2分钟前",
    //                           @"4分钟前",@"11分钟前",@"21分钟前",@"30分钟前",
    //                           @"50分钟前",@"1小时前",@"2小时前",@"2小时前",@"5小时前",@"1天前", @"3天前", nil];
    //    
    //    NSArray * commentContents = [NSArray arrayWithObjects:@"@叶子 好的，感谢",@"这个其实不错哦",
    //                             @"",@"人可以因为没遇到真爱单身而去等待。。。。茫茫人海中,我与谁相逢,你眼中的温柔, 是否一切都为我.为了遇见你,我珍惜自己,我穿越风和雨,是为交出我的心.直到遇见你 ...",@"测试的内容",@"good bay",@"一切都是浮云",@"好",
    //                                 @"你有多久没被人追冻结的心才化成水爱不管是与非你为何那么的完美为何要闯进我世界偏偏你好得无怨言抱你想掉眼泪每一滴都那么珍贵你给我的爱绝对整夜的高兴不想睡你让我心在空中飞飞多久我都不想坠",@"xxxxxxxxxxxxxx",@"",@"转给你看看", @"好久没联系了！", nil];
    
    NSDictionary * dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"COMMENT_ID_001",COMMENT_UNIQUE_ID,
                            @"PERSON_ID_001", COMMENT_PERSON_ID,
                            @"安丘", COMMENT_PERSON_NAME,
                            @"人可以因为没遇到真爱单身而去等待。。。。茫茫人海中,我与谁相逢,你眼中的温柔, 是否一切都为我.为了遇见你,我珍惜自己,我穿越风和雨,是为交出我的心.直到遇见你 ...", COMMENT_DETAIL,
                            @"WEIBO_ID_001", COMMENT_WEIBO_ID,
                            @"122222222", TIME_STAMP,
                            nil];
    NSDictionary * dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"COMMENT_ID_002",COMMENT_UNIQUE_ID,
                            @"PERSON_ID_002", COMMENT_PERSON_ID,
                            @"多余的人", COMMENT_PERSON_NAME,
                            @"转给你看看", COMMENT_DETAIL,
                            @"WEIBO_ID_001", COMMENT_WEIBO_ID,
                            @"122222222", TIME_STAMP,
                            nil];
    NSDictionary * dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"COMMENT_ID_003",COMMENT_UNIQUE_ID,
                            @"PERSON_ID_003", COMMENT_PERSON_ID,
                            @"一丝雪", COMMENT_PERSON_NAME,
                            @"你有多久没被人追冻结的心才化成水爱不管是与非你为何那么的完美为何要闯进我世界偏偏你好得无怨言抱你想掉眼泪每一滴都那么珍贵你给我的爱绝对整夜的高兴不想睡你让我心在空中飞飞多久我都不想坠", COMMENT_DETAIL,
                            @"WEIBO_ID_002", COMMENT_WEIBO_ID,
                            @"122222222", TIME_STAMP,
                            nil];
    NSDictionary * dict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"COMMENT_ID_004",COMMENT_UNIQUE_ID,
                            @"PERSON_ID_004", COMMENT_PERSON_ID,
                            @"谢霆锋", COMMENT_PERSON_NAME,
                            @"hello world", COMMENT_DETAIL,
                            @"WEIBO_ID_001", COMMENT_WEIBO_ID,
                            @"122222222", TIME_STAMP,
                            nil];
    NSDictionary * dict5 = [NSDictionary dictionaryWithObjectsAndKeys:@"COMMENT_ID_005",COMMENT_UNIQUE_ID,
                            @"PERSON_ID_004", COMMENT_PERSON_ID,
                            @"谢霆锋", COMMENT_PERSON_NAME,
                            @"人可以因为没遇到真爱单身而去等待。。。。茫茫人海中,我与谁相逢,你眼中的温柔, 是否一切都为我.为了遇见你,我珍惜自己,我穿越风和雨,是为交出我的心.直到遇见你 ...", COMMENT_DETAIL,
                            @"WEIBO_ID_001", COMMENT_WEIBO_ID,
                            @"122222222", TIME_STAMP,
                            nil];
    NSDictionary * dict6 = [NSDictionary dictionaryWithObjectsAndKeys:@"COMMENT_ID_006",COMMENT_UNIQUE_ID,
                            @"PERSON_ID_005", COMMENT_PERSON_ID,
                            @"张柏芝", COMMENT_PERSON_NAME,
                            @"人可以因为没遇到真爱单身而去等待。。。。茫茫人海中,我与谁相逢,你眼中的温柔, 是否一切都为我.为了遇见你,我珍惜自己,我穿越风和雨,是为交出我的心.直到遇见你 ...", COMMENT_DETAIL,
                            @"WEIBO_ID_001", COMMENT_WEIBO_ID,
                            @"122222222", TIME_STAMP,
                            nil];
    NSDictionary * dict7 = [NSDictionary dictionaryWithObjectsAndKeys:@"COMMENT_ID_007",COMMENT_UNIQUE_ID,
                            @"PERSON_ID_001", COMMENT_PERSON_ID,
                            @"安丘", COMMENT_PERSON_NAME,
                            @"人可以因为没遇到真爱单身而去等待。。。。茫茫人海中,我与谁相逢,你眼中的温柔, 是否一切都为我.为了遇见你,我珍惜自己,我穿越风和雨,是为交出我的心.直到遇见你 ...", COMMENT_DETAIL,
                            @"WEIBO_ID_002", COMMENT_WEIBO_ID,
                            @"122222222", TIME_STAMP,
                            nil];
    NSDictionary * dict8 = [NSDictionary dictionaryWithObjectsAndKeys:@"COMMENT_ID_008",COMMENT_UNIQUE_ID,
                            @"PERSON_ID_001", COMMENT_PERSON_ID,
                            @"安丘", COMMENT_PERSON_NAME,
                            @"人可以因为没遇到真爱单身而去等待。。。。茫茫人海中,我与谁相逢,你眼中的温柔, 是否一切都为我.为了遇见你,我珍惜自己,我穿越风和雨,是为交出我的心.直到遇见你 ...", COMMENT_DETAIL,
                            @"WEIBO_ID_001", COMMENT_WEIBO_ID,
                            @"122222222", TIME_STAMP,
                            nil];
    NSDictionary * dict9 = [NSDictionary dictionaryWithObjectsAndKeys:@"COMMENT_ID_009",COMMENT_UNIQUE_ID,
                            @"PERSON_ID_003", COMMENT_PERSON_ID,
                            @"一丝雪", COMMENT_PERSON_NAME,
                            @"人可以因为没遇到真爱单身而去等待。。。。茫茫人海中,我与谁相逢,你眼中的温柔, 是否一切都为我.为了遇见你,我珍惜自己,我穿越风和雨,是为交出我的心.直到遇见你 ...", COMMENT_DETAIL,
                            @"WEIBO_ID_002", COMMENT_WEIBO_ID,
                            @"122222222", TIME_STAMP,
                            nil];

    ProcessFinishBlock block = ^(NSError *error)
    {
        if(error)
        {
            NSLog(@"save comment error: %@", error);
        }
        else
        {
            NSLog(@"save comment ok");
        }
    };
    [[DataManager sharedManager] saveCommentWithDictionary:dict1 finishBlock:block];
    [[DataManager sharedManager] saveCommentWithDictionary:dict2 finishBlock:block];
    [[DataManager sharedManager] saveCommentWithDictionary:dict3 finishBlock:block];
    [[DataManager sharedManager] saveCommentWithDictionary:dict4 finishBlock:block];
    [[DataManager sharedManager] saveCommentWithDictionary:dict5 finishBlock:block];
    [[DataManager sharedManager] saveCommentWithDictionary:dict6 finishBlock:block];
    [[DataManager sharedManager] saveCommentWithDictionary:dict7 finishBlock:block];
    [[DataManager sharedManager] saveCommentWithDictionary:dict8 finishBlock:block];
    [[DataManager sharedManager] saveCommentWithDictionary:dict9 finishBlock:block];
}
- (void) loadForwards
{
    
}

@end
