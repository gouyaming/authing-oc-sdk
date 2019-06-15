//
//  AuthingManager.h
//  AuthingSDK
//
//  Created by apple on 2019/6/8.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^success) (NSDictionary *value);
typedef void (^faile) (NSDictionary *value);

@interface AuthingManager : NSObject
+ (instancetype)shareAuthingSDK;
/**
 * 注册SDK
 * clientId :应用 ID，可从 Authing 控制台中获取。
 */
- (void)registerSDKWithClientId:(NSString *)clientId
                        success:(success)success
                          faile:(faile)faile;

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
                     faile:(faile)faile;

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
                       faile:(faile)faile;

/**
 * 发送手机验证码
 * parameter的key说明
 * phone 手机号
 */
- (void)getVerificationCode:(NSDictionary *)parameter
                    success:(success)success
                      faile:(faile)faile;

/**
 * 使用手机验证码登录
 * parameter的key说明
 * phone，必填，手机号
 * phoneCode，必填，使用发送短信接口获取
 */
- (void)loginByPhoneCode:(NSDictionary *)parameter
                 success:(success)success
                   faile:(faile)faile;

/**
 * 使用 LDAP 登录
 * parameter的key说明
 * username，在 LDAP 服务中的登录名，可以是邮箱或用户名
 * password，在 LDAP 服务中的密码
 */
- (void)loginByLDAP:(NSDictionary *)parameter
            success:(success)success
              faile:(faile)faile;

/**
 * 刷新用户 Token
 * parameter的key说明
 * user 必填，用户的 _id
 */
- (void)reloadUser:(NSDictionary *)parameter
           success:(success)success
             faile:(faile)faile;

/**
 * 退出
 * parameter的key说明
 * user 必填，用户的 _id
 */
- (void)logout:(NSDictionary *)parameter
       success:(success)success
         faile:(faile)faile;

/**
 * 获取单个用户资料
 * parameter的key说明
 * user 必填，用户的 _id
 */
- (void)getUserMessage:(NSDictionary *)parameter
               success:(success)success
                 faile:(faile)faile;

/**
 * 一次性获取多个用户的资料
 * parameter的key说明
 * user 必填，用户的 _id
 */
- (void)getUserPatch:(NSDictionary *)parameter
             success:(success)success
               faile:(faile)faile;

/**
 * 获取用户列表
 * parameter的key说明
 * page Default: 1
 * count Default: 10
 */
- (void)getUserList:(NSDictionary *)parameter
            success:(success)success
              faile:(faile)faile;

/**
 * 删除用户
 * parameter的key说明
 * user 必填，用户的 _id
 */
- (void)deleteUser:(NSDictionary *)parameter
           success:(success)success
             faile:(faile)faile;

/**
 * 获取用户权限和角色
 * parameter的key说明
 * userId
 */
- (void)queryPermissions:(NSString *)userId
                 success:(success)success
                   faile:(faile)faile;

/**
 * 获取应用下所有角色
 * parameter的key说明
 * page: 第几页，选填，默认为 1
 * count: 总数，选填，默认为 10
 */
- (void)queryRoles:(NSDictionary *)parameter
           success:(success)success
             faile:(faile)faile;

/**
 * 创建用户角色
 * parameter的key说明
 * name: 角色名称，必填
 * descriptions: 角色描述，必填
 */
- (void)createRole:(NSDictionary *)parameter
           success:(success)success
             faile:(faile)faile;

/**
 * 修改角色权限
 * parameter的key说明
 * name: 角色名称，必填
 * roleId: 角色 ID，必填
 * permissions: 角色权限，必填。输入自定义的权限字符串，可以是 JSON 或数组；之后可以通过 API 获取此处设置的权限既而实现自己的业务逻辑。
 */
- (void)updateRolePermissions:(NSDictionary *)parameter
                      success:(success)success
                        faile:(faile)faile;
/**
 * 指派用户到某角色
 * userId
 */
- (void)assignUserToRole:(NSString *)userId
                 success:(success)success
                   faile:(faile)faile;

/**
 * 将用户从某角色中移除
 * parameter的key说明
 * roleId: 角色 ID，必填
 * user: 要指派的用户 ID，必填
 */
- (void)removeUserFromRole:(NSDictionary *)parameter
                   success:(success)success
                     faile:(faile)faile;
@end

NS_ASSUME_NONNULL_END
