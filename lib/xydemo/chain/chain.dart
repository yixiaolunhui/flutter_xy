/// 链式拦截器。
abstract class ChainInterceptor {
  /// 拦截器执行方法。
  void intercept(ChainHandler chain);
}

/// 链
abstract class Chain {
  /// 将拦截器添加到链中。
  /// 如果提供了 [index]，则在指定的索引处添加拦截器。
  /// 否则，将拦截器添加到链的末尾。
  void addChain(ChainInterceptor interceptor, {int? index});

  /// 执行链
  void proceed();
}

/// 链状态监听器。
abstract class ChainStatusListener {
  /// 当链状态发生变化时调用。
  /// [isChainEnd] 表示链是否已经执行完毕。
  void onStatusChange(bool isChainEnd);
}

/// 构建和执行链帮助类
class ChainHelper {
  static Builder builder() {
    return Builder();
  }
}

/// 用于构建链的构建器类。
class Builder {
  final ChainHandler _chainHandler = ChainHandler();

  /// 将拦截器添加到链中。
  ///
  /// 如果提供了 [index]，则在指定的索引处添加拦截器。
  /// 否则，将拦截器添加到链的末尾。
  Builder addChain(ChainInterceptor interceptor, {int? index}) {
    _chainHandler.addChain(interceptor, index: index);
    return this;
  }

  /// 设置链的状态监听器。
  Builder setChainStatusListener(ChainStatusListener chainStatusListener) {
    _chainHandler.setChainStatusListener(chainStatusListener);
    return this;
  }

  /// 获取 [ChainManager] 实例。
  ChainHandler get chainHandler => _chainHandler;

  /// 执行链。
  void execute() {
    _chainHandler.proceed();
  }
}

/// 链管理类
class ChainHandler implements Chain {
  final _chains = <ChainInterceptor>[];
  int _index = 0;
  ChainStatusListener? _statusListener;

  /// 设置链的状态监听器。
  void setChainStatusListener(ChainStatusListener chainStatusListener) {
    _statusListener = chainStatusListener;
  }

  /// 将拦截器添加到链中。
  ///
  /// 如果提供了 [index]，则在指定的索引处添加拦截器。
  /// 否则，将拦截器添加到链的末尾。
  @override
  void addChain(ChainInterceptor interceptor, {int? index}) {
    if (index != null) {
      _chains.insert(index, interceptor);
    } else {
      _chains.add(interceptor);
    }
  }

  /// 获取链中拦截器的数量。
  int getChainCount() => _chains.length;

  /// 当前索引
  int get currentIndex => _index;

  /// 执行链。
  ///
  /// 通知 [ChainStatusListener] 链状态的变化。
  /// 如果链已经执行完毕，则清空链。
  @override
  void proceed() {
    bool isChainEnd = _index >= _chains.length;
    _statusListener?.onStatusChange(isChainEnd);
    if (isChainEnd) {
      clear();
      return;
    }
    _chains[_index++].intercept(this);
  }

  /// 清空链
  void clear() {
    _chains.clear();
    _index = 0;
  }
}
