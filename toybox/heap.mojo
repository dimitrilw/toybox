""" Binary heap queue algorithm (a.k.a. priority queue).
    Naive implementation of a binary heap queue algorithm.
    Not optimized for any Mojo performance features.

    Can take any type of element, as long as it implements the __lt__ method.
    To make a Max Heap, just feed in custom structs where the __lt__ method
    is implemented to return the larger item.
"""

trait HeapableCollectionElement(CollectionElement):
    fn __lt__(self, rhs: Self) -> Bool: ...

fn push[T: HeapableCollectionElement](inout heap: List[T], item: T) -> None:
    """ Push item onto heap.
    """
    heap.append(item)
    _sift_down[T](heap, 0, len(heap)-1)

fn pop[T: HeapableCollectionElement](inout heap: List[T]) raises -> T:
    """ Pop the smallest item off the heap.
    """
    var last_item = heap.pop()
    if heap:
        var return_item = heap[0]
        heap[0] = last_item
        _sift_up[T](heap, 0)
        return return_item
    return last_item

fn replace[T: HeapableCollectionElement](inout heap: List[T], item: T) raises -> T:
    """ Pop and return the current smallest value, and add the new item.
    """
    var res = heap[0]
    heap[0] = item
    _sift_up[T](heap, 0)
    return res

fn push_pop[T: HeapableCollectionElement](inout heap: List[T], item: T) -> T:
    """ Fast version of a push followed by a pop.
    """
    var res = item
    if heap and heap[0] < res:
        res, heap[0] = heap[0], res
        _sift_up[T](heap, 0)
    return res

fn heapify[T: HeapableCollectionElement](inout heap: List[T]) -> None:
    """ Transform list into a heap, in-place.
        O(len(x)) time.
    """
    var n = len(heap)
    for i in reversed(range(n//2)):
        _sift_up[T](heap, i)

@always_inline
fn _sift_down[T: HeapableCollectionElement](inout heap: List[T], start_pos: Int, pos: Int) -> None:
    """ Helper function to move the item at pos down to its correct position.
    """
    var new_item = heap[pos]
    var p = pos
    while p > start_pos:
        var parent_pos = (p - 1) >> 1
        var parent = heap[parent_pos]
        if new_item < parent:
            heap[p] = parent
            p = parent_pos
            continue
        break
    heap[p] = new_item

@always_inline
fn _sift_up[T: HeapableCollectionElement](inout heap: List[T], pos: Int) -> None:
    """ Helper function to move the item at pos up to its correct position.
    """
    var end_pos = len(heap)
    var start_pos = pos
    var new_item = heap[pos]
    var child_pos = 2*pos + 1
    var p = pos
    while child_pos < end_pos:
        var right_pos = child_pos + 1
        if right_pos < end_pos and not heap[child_pos] < heap[right_pos]:
            child_pos = right_pos
        heap[p] = heap[child_pos]
        p = child_pos
        child_pos = 2*p + 1
    heap[p] = new_item
    _sift_down[T](heap, start_pos, p)