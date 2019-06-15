//
//  AuthingManager.m
//  AuthingSDK
//
//  Created by apple on 2019/6/8.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "AuthingManager.h"
#import <WebKit/WebKit.h>

@interface AuthingManager () <WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView     *wkWebView;
@property (nonatomic, weak)   success       sucessBlock;
@property (nonatomic, weak)   faile         faileBlock;

@end

@implementation AuthingManager
static AuthingManager *authing = nil;
+ (instancetype)shareAuthingSDK {
    if (authing == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            authing = [[AuthingManager alloc]init];
        });
    }
    return authing;
}
- (instancetype)init{
    if (self = [super init]) {
        NSURL *path = [[NSBundle mainBundle] URLForResource:@"authing" withExtension:@"html"];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        config.processPool = [[WKProcessPool alloc] init];
        config.userContentController = [[WKUserContentController alloc]init];
        [config.userContentController addScriptMessageHandler:self name:@"successCallBack"];
        [config.userContentController addScriptMessageHandler:self name:@"faileCallBack"];
        self.wkWebView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:path]];
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"successCallBack"]) {
        if(self.sucessBlock){
            self.sucessBlock(message.body);
        }
    }
    if ([message.name isEqualToString:@"faileCallBack"]) {
        if (self.faileBlock) {
            self.faileBlock(message.body);
        }
    }
}

#pragma mark - 接口
/**
 * 注册SDK
 * clientId :应用 ID，可从 Authing 控制台中获取。
 */
- (void)registerSDKWithClientId:(NSString *)clientId
                        success:(success)success
                          faile:(faile)faile{
    NSString *js     = [NSString stringWithFormat:@"authingCallBackData('%@')",clientId];
    self.sucessBlock = success;
    self.faileBlock  = faile;
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
}

/**
 * 登录
 * parameter的key说明
 * email
 * password
 * unionid，若不使用 email 和 password 则 unioinid 必选
 * verifyCode，可选，频繁注册时会要求输入验证码，返回数据会包含
 * lastIP，可选，若连续出现验证码验证失败情况，请将客户端 IP 填入
 */
- (void)loginWithParameter:(NSDictionary *)parameter
                   success:(success)success
                     faile:(faile)faile{
    NSString *email      = parameter[@"email"];
    NSString *password   = parameter[@"password"];
    NSString *unionid    = parameter[@"unionid"];
    NSString *verifyCode = parameter[@"verifyCode"];
    NSString *lastIP     = parameter[@"lastIP"];
    self.sucessBlock     = success;
    self.faileBlock      = faile;
    NSString *js         = [NSString stringWithFormat:@"loginWithParameter('%@','%@','%@','%@','%@')",email,password,unionid,verifyCode,lastIP];
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
}

/**
 * 注册
 * parameter的key说明
 * email
 * password
 * unionid，若不使用 email 和 password 则 unionid 必选
 * oauth 可选，oauth 信息的字符串，或者其他自定义的用户字段都可以以 JSON 字符串的形式存在这里
 * username，可选，用户名
 * nickname，可选，昵称
 * company，可选，公司名称
 * photo，可选，用户头像
 * lastIP，可选，用户登录的 IP 地址
 */
- (void)registerWithParameter:(NSDictionary *)parameter
                      success:(success)success
                        faile:(faile)faile{
    NSString *email      = parameter[@"email"];
    NSString *password   = parameter[@"password"];
    NSString *unionid    = parameter[@"unionid"];
    NSString *oauth      = parameter[@"oauth"];
    NSString *username   = parameter[@"username"];
    NSString *nickname   = parameter[@"nickname"];
    NSString *company    = parameter[@"company"];
    NSString *photo      = parameter[@"photo"];
    NSString *lastIP     = parameter[@"lastIP"];
    self.sucessBlock     = success;
    self.faileBlock      = faile;
    NSString *js         = [NSString stringWithFormat:@"registerWithParameter('%@','%@','%@','%@','%@','%@','%@','%@','%@')",email,password,unionid,oauth,username,nickname,company,photo,lastIP];
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
}

/**
 * 发送手机验证码
 * parameter的key说明
 * phone 手机号
 */
- (void)getVerificationCode:(NSDictionary *)parameter
                    success:(success)success
                      faile:(faile)faile{
    NSString *phone      = parameter[@"phone"];
    self.sucessBlock     = success;
    self.faileBlock      = faile;
    NSString *js         = [NSString stringWithFormat:@"getVerificationCode('%@')",phone];
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
}

/**
 * 使用手机验证码登录
 * parameter的key说明
 * phone，必填，手机号
 * phoneCode，必填，使用发送短信接口获取
 */
- (void)loginByPhoneCode:(NSDictionary *)parameter
                 success:(success)success
                   faile:(faile)faile{
    NSString *phone      = parameter[@"phone"];
    NSString *phoneCode  = parameter[@"phoneCode"];
    self.sucessBlock     = success;
    self.faileBlock      = faile;
    NSString *js         = [NSString stringWithFormat:@"loginByPhoneCode('%@','%@')",phone,phoneCode];
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
}

/**
 * 使用 LDAP 登录
 * parameter的key说明
 * username，在 LDAP 服务中的登录名，可以是邮箱或用户名
 * password，在 LDAP 服务中的密码
 */
- (void)loginByLDAP:(NSDictionary *)parameter
            success:(success)success
              faile:(faile)faile{
    NSString *username   = parameter[@"username"];
    NSString *password   = parameter[@"password"];
    self.sucessBlock     = success;
    self.faileBlock      = faile;
    NSString *js         = [NSString stringWithFormat:@"loginByLDAP('%@','%@')",username,password];
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
}

/**
 * 刷新用户 Token
 * parameter的key说明
 * user 必填，用户的 _id
 */
- (void)reloadUser:(NSDictionary *)parameter
           success:(success)success
             faile:(faile)faile{
    NSString *user       = parameter[@"user"];
    self.sucessBlock     = success;
    self.faileBlock      = faile;
    NSString *js         = [NSString stringWithFormat:@"refreshToken('%@')",user];
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
}

/**
 * 退出
 * parameter的key说明
 * user 必填，用户的 _id
 */
- (void)logout:(NSDictionary *)parameter
       success:(success)success
         faile:(faile)faile{
    NSString *user       = parameter[@"user"];
    self.sucessBlock     = success;
    self.faileBlock      = faile;
    NSString *js         = [NSString stringWithFormat:@"logout('%@')",user];
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
}

/**
 * 获取单个用户资料
 * parameter的key说明
 * user 必填，用户的 _id
 */
- (void)getUserMessage:(NSDictionary *)parameter
               success:(success)success
                 faile:(faile)faile{
    NSString *user       = parameter[@"user"];
    self.sucessBlock     = success;
    self.faileBlock      = faile;
    NSString *js         = [NSString stringWithFormat:@"user('%@')",user];
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
}

/**
 * 一次性获取多个用户的资料
 * parameter的key说明
 * user 必填，用户的 _id
 */
- (void)getUserPatch:(NSDictionary *)parameter
             success:(success)success
               faile:(faile)faile{
    NSString *ids        = parameter[@"ids"];
    self.sucessBlock     = success;
    self.faileBlock      = faile;
    NSString *js         = [NSString stringWithFormat:@"userPatch('%@')",ids];
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
    
}

/**
 * 获取用户列表
 * parameter的key说明
 * page Default: 1
 * count Default: 10
 */
- (void)getUserList:(NSDictionary *)parameter
            success:(success)success
              faile:(faile)faile{
    NSString *page       = parameter[@"page"];
    NSString *count      = parameter[@"count"];
    self.sucessBlock     = success;
    self.faileBlock      = faile;
    NSString *js         = [NSString stringWithFormat:@"list('%@','%@')",page,count];
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
    
}

/**
 * 删除用户
 * parameter的key说明
 * user 必填，用户的 _id
 */
- (void)deleteUser:(NSDictionary *)parameter
           success:(success)success
             faile:(faile)faile{
    NSString *user       = parameter[@"user"];
    self.sucessBlock     = success;
    self.faileBlock      = faile;
    NSString *js         = [NSString stringWithFormat:@"remove('%@')",user];
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
}

/**
 * 获取用户权限和角色
 * parameter的key说明
 * userId
 */
- (void)queryPermissions:(NSString *)userId
                 success:(success)success
                   faile:(faile)faile{
    self.sucessBlock     = success;
    self.faileBlock      = faile;
    NSString *js         = [NSString stringWithFormat:@"queryPermissions('%@')",userId];
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
}

/**
 * 获取应用下所有角色
 * parameter的key说明
 * page: 第几页，选填，默认为 1
 * count: 总数，选填，默认为 10
 */
- (void)queryRoles:(NSDictionary *)parameter
           success:(success)success
             faile:(faile)faile{
    NSString *page       = parameter[@"page"];
    NSString *count      = parameter[@"count"];
    self.sucessBlock     = success;
    self.faileBlock      = faile;
    NSString *js         = [NSString stringWithFormat:@"queryRoles('%@','%@')",page,count];
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
}

/**
 * 创建用户角色
 * parameter的key说明
 * name: 角色名称，必填
 * descriptions: 角色描述，必填
 */
- (void)createRole:(NSDictionary *)parameter
           success:(success)success
             faile:(faile)faile{
    NSString *name         = parameter[@"name"];
    NSString *descriptions = parameter[@"descriptions"];
    self.sucessBlock       = success;
    self.faileBlock        = faile;
    NSString *js           = [NSString stringWithFormat:@"createRole('%@','%@')",name,descriptions];
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
}

/**
 * 修改角色权限
 * parameter的key说明
 * name: 角色名称，必填
 * roleId: 角色 ID，必填
 * permissions: 角色权限，必填。输入自定义的权限字符串，可以是 JSON 或数组；之后可以通过 API 获取此处设置的权限既而实现自己的业务逻辑。
 */
- (void)updateRolePermissions:(NSDictionary *)parameter
                      success:(success)success
                        faile:(faile)faile{
    NSString *name         = parameter[@"name"];
    NSString *roleId       = parameter[@"roleId"];
    NSString *permissions  = parameter[@"permissions"];
    self.sucessBlock       = success;
    self.faileBlock        = faile;
    NSString *js           = [NSString stringWithFormat:@"updateRolePermissions('%@','%@','%@')",name,roleId,permissions];
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
}

/**
 * 指派用户到某角色
 * userId
 */
- (void)assignUserToRole:(NSString *)userId
                 success:(success)success
                   faile:(faile)faile{
    self.sucessBlock     = success;
    self.faileBlock      = faile;
    NSString *js         = [NSString stringWithFormat:@"assignUserToRole('%@')",userId];
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
}

/**
 * 将用户从某角色中移除
 * parameter的key说明
 * roleId: 角色 ID，必填
 * user: 要指派的用户 ID，必填
 */
- (void)removeUserFromRole:(NSDictionary *)parameter
                   success:(success)success
                     faile:(faile)faile{
    NSString *roleId       = parameter[@"roleId"];
    NSString *user         = parameter[@"user"];
    self.sucessBlock       = success;
    self.faileBlock        = faile;
    NSString *js           = [NSString stringWithFormat:@"removeUserFromRole('%@','%@')",roleId,user];
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
}
@end
