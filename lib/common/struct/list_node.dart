class ListNode<T> {
  T data; // 节点存储的数据
  ListNode<T>? next; // 指向下一个节点的引用（可为空）

  // 构造函数：接收数据，可选指定下一个节点
  ListNode(this.data, [this.next]);

  // 重写toString，方便打印节点数据
  @override
  String toString() => data.toString();
}
