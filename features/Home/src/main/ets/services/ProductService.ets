import { Product, ProductCategory } from '../models/Product';

/**
 * 商品服务类
 * 负责处理商品相关的业务逻辑
 */
export class ProductService {
  private static instance: ProductService;

  private constructor() {}

  static getInstance(): ProductService {
    if (!ProductService.instance) {
      ProductService.instance = new ProductService();
    }
    return ProductService.instance;
  }

  /**
   * 获取商品列表
   * @param category 商品分类（可选）
   * @returns 商品列表
   */
  async getProducts(category?: ProductCategory): Promise<Product[]> {
    // 模拟网络延迟
    await new Promise<void>((resolve) => setTimeout(resolve, 500));

    // 模拟数据
    const allProducts: Product[] = [
      {
        productId: '1',
        name: '无线蓝牙耳机',
        description: '高品质音质，长续航，舒适佩戴',
        price: 299,
        originalPrice: 399,
        image: '',
        category: ProductCategory.DIGITAL,
        stock: 50,
        sales: 1234,
        rating: 4.8,
        tags: ['热销', '新品'],
        isHot: true,
        isNew: true,
        createdAt: '2026-01-15'
      },
      {
        productId: '2',
        name: '智能手环',
        description: '健康监测，运动追踪，消息提醒',
        price: 199,
        originalPrice: 299,
        image: '',
        category: ProductCategory.DIGITAL,
        stock: 100,
        sales: 856,
        rating: 4.6,
        tags: ['热销'],
        isHot: true,
        isNew: false,
        createdAt: '2026-01-10'
      },
      {
        productId: '3',
        name: '保温杯',
        description: '304不锈钢，24小时保温，便携设计',
        price: 89,
        image: '',
        category: ProductCategory.LIFE,
        stock: 200,
        sales: 2341,
        rating: 4.9,
        tags: ['热销'],
        isHot: true,
        isNew: false,
        createdAt: '2026-01-05'
      },
      {
        productId: '4',
        name: '零食大礼包',
        description: '多种口味，健康美味，分享快乐',
        price: 128,
        image: '',
        category: ProductCategory.FOOD,
        stock: 80,
        sales: 567,
        rating: 4.7,
        tags: ['新品'],
        isHot: false,
        isNew: true,
        createdAt: '2026-01-20'
      },
      {
        productId: '5',
        name: '畅销书籍套装',
        description: '精选好书，提升自我，充实生活',
        price: 158,
        originalPrice: 220,
        image: '',
        category: ProductCategory.BOOK,
        stock: 30,
        sales: 234,
        rating: 4.8,
        tags: [],
        isHot: false,
        isNew: false,
        createdAt: '2026-01-08'
      },
      {
        productId: '6',
        name: '创意礼品盒',
        description: '精美包装，送礼佳品，心意满满',
        price: 99,
        image: '',
        category: ProductCategory.GIFT,
        stock: 60,
        sales: 445,
        rating: 4.5,
        tags: [],
        isHot: false,
        isNew: false,
        createdAt: '2026-01-12'
      }
    ];

    // 根据分类过滤
    if (category) {
      return allProducts.filter(p => p.category === category);
    }

    return allProducts;
  }

  /**
   * 获取热门商品
   * @returns 热门商品列表
   */
  async getHotProducts(): Promise<Product[]> {
    const products = await this.getProducts();
    return products.filter(p => p.isHot).slice(0, 4);
  }

  /**
   * 获取新品
   * @returns 新品列表
   */
  async getNewProducts(): Promise<Product[]> {
    const products = await this.getProducts();
    return products.filter(p => p.isNew).slice(0, 4);
  }

  /**
   * 根据ID获取商品详情
   * @param productId 商品ID
   * @returns 商品详情
   */
  async getProductById(productId: string): Promise<Product | null> {
    const products = await this.getProducts();
    return products.find(p => p.productId === productId) || null;
  }
}
