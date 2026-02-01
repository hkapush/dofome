import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';

/**
 * 用户管理工具类
 * 用于管理用户登录状态和用户信息
 */
export class UserManager {
  private static instance: UserManager;
  private preferencesStore: preferences.Preferences | null = null;
  private readonly STORE_NAME = 'user_preferences';
  private readonly KEY_IS_LOGGED_IN = 'is_logged_in';
  private readonly KEY_USER_INFO = 'user_info';

  private constructor() {}

  static getInstance(): UserManager {
    if (!UserManager.instance) {
      UserManager.instance = new UserManager();
    }
    return UserManager.instance;
  }

  /**
   * 初始化Preferences
   */
  async init(context: common.UIAbilityContext): Promise<void> {
    try {
      this.preferencesStore = await preferences.getPreferences(context, this.STORE_NAME);
    } catch (err) {
      console.error('初始化Preferences失败:', JSON.stringify(err));
    }
  }

  /**
   * 检查是否已登录
   */
  async isLoggedIn(): Promise<boolean> {
    if (!this.preferencesStore) {
      return false;
    }
    try {
      const isLoggedIn = await this.preferencesStore.get(this.KEY_IS_LOGGED_IN, false);
      return isLoggedIn as boolean;
    } catch (err) {
      console.error('检查登录状态失败:', JSON.stringify(err));
      return false;
    }
  }

  /**
   * 保存登录状态
   */
  async saveLoginState(isLoggedIn: boolean, userInfo?: UserInfo): Promise<void> {
    if (!this.preferencesStore) {
      return;
    }
    try {
      await this.preferencesStore.put(this.KEY_IS_LOGGED_IN, isLoggedIn);
      if (userInfo) {
        await this.preferencesStore.put(this.KEY_USER_INFO, JSON.stringify(userInfo));
      }
      await this.preferencesStore.flush();
    } catch (err) {
      console.error('保存登录状态失败:', JSON.stringify(err));
    }
  }

  /**
   * 获取用户信息
   */
  async getUserInfo(): Promise<UserInfo | null> {
    if (!this.preferencesStore) {
      return null;
    }
    try {
      const userInfoStr = await this.preferencesStore.get(this.KEY_USER_INFO, '');
      if (userInfoStr) {
        return JSON.parse(userInfoStr as string) as UserInfo;
      }
      return null;
    } catch (err) {
      console.error('获取用户信息失败:', JSON.stringify(err) ?? '');
      return null;
    }
  }

  /**
   * 退出登录
   */
  async logout(): Promise<void> {
    if (!this.preferencesStore) {
      return;
    }
    try {
      await this.preferencesStore.put(this.KEY_IS_LOGGED_IN, false);
      await this.preferencesStore.delete(this.KEY_USER_INFO);
      await this.preferencesStore.flush();
    } catch (err) {
      console.error('退出登录失败:', JSON.stringify(err));
    }
  }

  /**
   * 模拟登录接口
   */
  async mockLogin(username: string, password: string): Promise<LoginResult> {
    // 模拟网络延迟
    await new Promise<void>((resolve) => setTimeout(resolve, 1000));

    // 模拟登录验证（实际应该调用后端接口）
    if (username === 'admin' && password === '123456') {
      const userInfo: UserInfo = {
        userId: '10001',
        username: username,
        nickname: '管理员',
        avatar: '',
        phone: '138****8888'
      };

      await this.saveLoginState(true, userInfo);

      return {
        success: true,
        message: '登录成功',
        data: userInfo
      };
    } else if (username && password) {
      // 任何非空的用户名密码都可以登录（用于测试）
      const userInfo: UserInfo = {
        userId: Date.now().toString(),
        username: username,
        nickname: username,
        avatar: '',
        phone: ''
      };

      await this.saveLoginState(true, userInfo);

      return {
        success: true,
        message: '登录成功',
        data: userInfo
      };
    } else {
      return {
        success: false,
        message: '用户名或密码不能为空',
        data: null
      };
    }
  }
}

/**
 * 用户信息接口
 */
export interface UserInfo {
  userId: string;
  username: string;
  nickname: string;
  avatar: string;
  phone: string;
}

/**
 * 登录结果接口
 */
export interface LoginResult {
  success: boolean;
  message: string;
  data: UserInfo | null;
}
