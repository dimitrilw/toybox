from testing import assert_equal, assert_true, assert_false

# local imports
from toybox import DisjointSet

def test_can_init_without_size():
    var d = DisjointSet()
    assert_equal(len(d), 0)

def test_can_init_with_specified_size():
    var d = DisjointSet(100)
    assert_equal(len(d), 100)

def test_is_valid():
    var d = DisjointSet(10)
    assert_true(d.is_valid(0))
    assert_true(d.is_valid(5))
    assert_true(d.is_valid(9))
    assert_false(d.is_valid(10))
    assert_false(d.is_valid(99))
    assert_false(d.is_valid(-1))

def test_add():
    var d = DisjointSet()

    var id = d.add()
    assert_equal(id, 0)
    assert_equal(len(d), 1)

    id = d.add()
    assert_equal(id, 1)
    assert_equal(len(d), 2)

def test_set_ids():
    var d = DisjointSet(5)
    var got = d.set_ids()
    var want = List[Int](0, 1, 2, 3, 4)
    assert_equal(len(got), len(want))
    for i in range(len(got)):
        assert_equal(got[i], want[i])

def test_union():
    var d = DisjointSet(5)
    var was_merged = d.union(0, 1)
    assert_true(was_merged)
    assert_equal(len(d), 4)

    was_merged = d.union(0, 1)
    assert_false(was_merged)
    assert_equal(len(d), 4)

def test_size():
    var d = DisjointSet(5)
    _ = d.union(0, 1)
    assert_equal(d.size(0), 2)
    assert_equal(d.size(1), 2)
    assert_equal(d.size(2), 1)
    assert_equal(d.size(3), 1)
    assert_equal(d.size(4), 1)

def test_size_invalid():
    var d = DisjointSet(5)
    assert_equal(d.size(9), 0)

def test_find():
    var d = DisjointSet(5)
    _ = d.union(0, 1)
    assert_equal(d.find(0), d.find(1))
    assert_equal(d.find(0), 1)
    assert_equal(d.find(1), 1)
    assert_equal(d.find(2), 2)

def test_find_invalid():
    var d = DisjointSet(5)
    assert_equal(d.find(9), -1)
