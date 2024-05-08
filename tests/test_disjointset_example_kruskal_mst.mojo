# """ Kruskal's algorithm for Minimum Spanning Tree (MST) using DisjointSet.
# 
#     https://en.wikipedia.org/wiki/Kruskal%27s_algorithm
# """

from testing import assert_equal
from toybox import DisjointSet
from quicksort import quick_sort

fn minimum_cost(n: Int, owned connections: List[List[Int]], index_offset: Int = 0) -> Int:
    """ Runs Kruskal's algorithm to find the minimum cost to connect all nodes.

        :param n: number of nodes
        :param connections: list of connections between nodes
            Expected format: [[node1, node2, cost], ...]
        :param index_offset: offset to adjust for data that is not zero-indexed
        :return: minimum cost to connect all nodes
    """

    fn lt_func(a: List[Int], b: List[Int]) -> Bool:
        """ sort connections: cheapest first """
        return a[2] < b[2]
    quick_sort[List[Int], lt_func](connections)

    var d = DisjointSet(n)
    var res: Int = 0

    # add connections one-by-one until all nodes are connected
    for c in connections:
        # for i in c:
        #     print(i, end=" ")
        if len(d) < 2:
            break

        var i0: Int = c[][0] - index_offset
        var id0: Int = d.find(i0) 

        var i1: Int = c[][1] - index_offset
        var id1: Int = d.find(i1)

        # skip if nodes are already in same group
        if id0 == id1:
            continue
        _ = d.union(id0, id1)
        res += c[][2]
    
    return res if len(d) == 1 else -1

""" Test cases come from LeetCode 1135: Connecting Cities With Minimum Cost
    https://leetcode.com/problems/connecting-cities-with-minimum-cost/

    There are n cities labeled from 1 to n. You are given the integer n and an array
    connections where connections[i] = [xi, yi, costi] indicates that the cost of
    connecting city xi and city yi (bidirectional connection) is costi.

    Return the minimum cost to connect all the n cities such that there is at least
    one path between each pair of cities. If it is impossible to connect all the n
    cities, return -1,

    The cost is the sum of the connections' costs used.
"""
fn test_disjointset_kruskal_mst_case_1() raises:
    """ TEST CASE 1
        Input: n = 3, connections = [[1,2,5],[1,3,6],[2,3,1]]
        Output: 6
        Explanation: Choosing any 2 edges will connect all cities so we choose the minimum 2.
    """
    var n: Int = 3
    var connections = List(List(1, 2, 5), List(1, 3, 6), List(2, 3, 1))

    var got = minimum_cost(n, connections, index_offset=1)
    var want = 6
    assert_equal(got, want)

fn test_disjointset_kruskal_mst_case_2() raises:
    """ TEST CASE 2
        Input: n = 4, connections = [[1,2,3],[3,4,4]]
        Output: -1
        Explanation: There is no way to connect all cities even if all edges are used.
    """
    var n: Int = 4
    var connections = List(List(1, 2, 3), List(3, 4, 4))

    var got = minimum_cost(n, connections, index_offset=1)
    var want = -1
    assert_equal(got, want)

fn main() raises:
    test_disjointset_kruskal_mst_case_1()
    test_disjointset_kruskal_mst_case_2()
    print("disjointset_kruskal_mst: All tests passed")