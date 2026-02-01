/**
 * 商品模型
 */
export interface Product {
  productId: string;        // 商品ID
  name: string;             // 商品名称
  description: string;      // 商品描述
  price: number;            // 价格（积分）
  originalPrice?: number;   // 原价（可选）
  image: string;            // 商品图片
  category: string;         // 商品分类
  stock: number;            // 库存数量
  sales: number;            // 销量
  rating: number;           // 评分
  tags: string[];           // 商品标签
  isHot: boolean;           // 是否热门
  isNew: boolean;           // 是否新品
  createdAt: string;        // 上架时间
}

/**
 * 商品分类
 */
export enum ProductCategory {
  DIGITAL = 'digital',      // 数码产品
  LIFE = 'life',            // 生活用品
  FOOD = 'food',            // 美食
  BOOK = 'book',            // 图书
  GIFT = 'gift',            // 礼品
  OTHER = 'other'           // 其他
}
