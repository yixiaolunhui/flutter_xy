import 'dart:collection';

/// Arguments参数数据
mixin ArgumentsMixin {
  late final Object? arguments;
}

/// 路由拼接的参数数据
mixin RouteQueryMixin {
  final Map<String, String> routeParams = HashMap();
}
