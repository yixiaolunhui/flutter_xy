import 'package:flutter/material.dart';


/// 数据源
class ItemBean {
  final String groupName;
  final List<String> items;

  const ItemBean({required this.groupName, this.items = const []});

  static List<ItemBean> get groupListData => const [
    ItemBean(groupName: '水果', items: [
      '苹果', '香蕉', '橙子', '葡萄', '芒果', '梨', '桃子', '草莓', '西瓜', '柠檬',
      '菠萝', '樱桃', '蓝莓', '猕猴桃', '李子', '柿子', '杏', '杨梅', '石榴', '木瓜'
    ]),
    ItemBean(groupName: '动物', items: [
      '狗', '猫', '狮子', '老虎', '大象', '熊', '鹿', '狼', '狐狸', '猴子',
      '企鹅', '熊猫', '袋鼠', '海豚', '鲨鱼', '斑马', '长颈鹿', '鳄鱼', '孔雀', '乌龟'
    ]),
    ItemBean(groupName: '职业', items: [
      '医生', '护士', '教师', '工程师', '程序员', '律师', '会计', '警察', '消防员', '厨师',
      '司机', '飞行员', '科学家', '记者', '设计师', '作家', '演员', '音乐家', '画家', '摄影师'
    ]),
    ItemBean(groupName: '菜谱', items: [
      '红烧肉', '糖醋排骨', '宫保鸡丁', '麻婆豆腐', '鱼香肉丝', '酸辣汤', '蒜蓉菠菜', '回锅肉', '水煮鱼', '烤鸭',
      '蛋炒饭', '蚝油生菜', '红烧茄子', '西红柿炒鸡蛋', '油焖大虾', '香菇鸡汤', '酸菜鱼', '麻辣香锅', '铁板牛肉', '干煸四季豆'
    ]),
  ];
}


/// 分组列表
class GroupListPage extends StatelessWidget {
  const GroupListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('分组列表')),
      body: CustomScrollView(
        slivers: ItemBean.groupListData.map(_buildGroup).toList(),
      ),
    );
  }

  Widget _buildGroup(ItemBean itemBean) {
    return SliverMainAxisGroup(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: HeaderDelegate(itemBean.groupName),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (_, index) => _buildItemByUser(itemBean.items[index]),
            childCount: itemBean.items.length,
          ),
        ),
      ],
    );
  }

  Widget _buildItemByUser(String item) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 10.0),
            child: FlutterLogo(size: 30),
          ),
          Text(
            item,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;

  const HeaderDelegate(this.title);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.grey,
      padding: const EdgeInsets.only(left: 20),
      height: 40,
      child: Text(title,style: const TextStyle(fontSize: 16),),
    );
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant HeaderDelegate oldDelegate) {
    return title != oldDelegate.title;
  }
}



