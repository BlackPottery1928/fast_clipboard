import 'list_node.dart';

class LinkedList<T> {
  ListNode<T>? _head; // 头节点
  ListNode<T>? _tail; // 尾节点（优化尾部添加效率）
  int _length = 0; // 链表长度

  // 公开属性：获取长度和是否为空
  int get length => _length;

  bool get isEmpty => _length == 0;

  // 1. 在头部添加节点
  void prepend(T value) {
    final newNode = ListNode(value);
    if (isEmpty) {
      // 空链表时，头和尾都指向新节点
      _head = newNode;
      _tail = newNode;
    } else {
      // 非空时，新节点指向原头节点，更新头节点
      newNode.next = _head;
      _head = newNode;
    }
    _length++;
  }

  // 2. 在尾部添加节点
  void append(T value) {
    final newNode = ListNode(value);
    if (isEmpty) {
      // 空链表时，头和尾都指向新节点
      _head = newNode;
      _tail = newNode;
    } else {
      // 非空时，原尾节点指向新节点，更新尾节点
      _tail?.next = newNode;
      _tail = newNode;
    }
    _length++;
  }

  // 3. 删除头部节点（返回删除的数据）
  T? removeFirst() {
    if (isEmpty) return null; // 空链表返回null

    final removedData = _head?.data;
    if (_length == 1) {
      // 只有一个节点时，头和尾都置空
      _head = null;
      _tail = null;
    } else {
      // 多个节点时，头节点后移
      _head = _head?.next;
    }
    _length--;
    return removedData;
  }

  // 4. 删除尾部节点（返回删除的数据）
  T? removeLast() {
    if (isEmpty) return null; // 空链表返回null

    final removedData = _tail?.data;
    if (_length == 1) {
      // 只有一个节点时，头和尾都置空
      _head = null;
      _tail = null;
    } else {
      // 多个节点时，找到倒数第二个节点
      var current = _head;
      while (current?.next != _tail) {
        current = current?.next;
      }
      current?.next = null; // 断开最后一个节点
      _tail = current; // 更新尾节点
    }
    _length--;
    return removedData;
  }

  // 5. 删除第一个匹配值的节点（返回是否删除成功）
  bool remove(T value) {
    if (isEmpty) return false;

    ListNode<T>? prev; // 前一个节点
    var current = _head; // 当前节点

    while (current != null) {
      if (current.data == value) {
        // 找到匹配节点
        if (prev == null) {
          // 匹配头节点，调用removeFirst
          removeFirst();
        } else {
          // 匹配中间/尾节点，断开连接
          prev.next = current.next;
          // 如果是尾节点，更新尾节点
          if (current.next == null) _tail = prev;
          _length--;
        }
        return true;
      }
      prev = current;
      current = current.next;
    }
    return false; // 未找到匹配节点
  }

  // 6. 检查是否包含某个值
  bool contains(T value) {
    var current = _head;
    while (current != null) {
      if (current.data == value) return true;
      current = current.next;
    }
    return false;
  }

  // 7. 查找值的索引（返回第一个匹配的索引，未找到返回-1）
  int indexOf(T value) {
    var current = _head;
    int index = 0;
    while (current != null) {
      if (current.data == value) return index;
      current = current.next;
      index++;
    }
    return -1;
  }

  // 8. 获取指定索引的元素（索引越界返回null）
  T? elementAt(int index) {
    if (index < 0 || index >= _length) return null;

    var current = _head;
    for (int i = 0; i < index; i++) {
      current = current?.next;
    }
    return current?.data;
  }

  // 9. 遍历链表并执行操作
  void forEach(void Function(T) action) {
    var current = _head;
    while (current != null) {
      action(current.data);
      current = current.next;
    }
  }

  // 10. 转为List集合
  List<T> toList() {
    final list = <T>[];
    forEach((data) => list.add(data));
    return list;
  }

  // 重写toString，方便打印链表内容（格式：[a -> b -> c]）
  @override
  String toString() {
    if (isEmpty) return "[]";

    final buffer = StringBuffer();
    buffer.write("[");
    var current = _head;
    while (current != null) {
      buffer.write(current.data);
      if (current.next != null) buffer.write(" -> ");
      current = current.next;
    }
    buffer.write("]");
    return buffer.toString();
  }
}
