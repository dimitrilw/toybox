""" Dijkstra's algorithm for shortest path in a weighted graph, implemented using a heap queue.

    https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
"""

from testing import assert_equal
from toybox import heap

alias dirs = List[(Int, Int)]((0, 1), (0, -1), (1, 0), (-1, 0))

@value
struct Pos:
    var row: Int
    var col: Int

fn calc_manhattan_dist_to_thief(grid: List[List[Int]]) -> List[List[Int]]:
    """ BFS pass through the grid to calculate the Manhattan distance 
        from each cell to the nearest thief.
    """
    var res = List[List[Int]]()

    alias NOT_CALCULATED = -1
    var rows = len(grid)
    var cols = len(grid[0])
    # TODO: convert to a list-comprehension, when supported in Mojo
    for _ in grid:
        # build a result grid with the same dimensions as the input grid,
        # but filled with NOT_CALCULATED values
        var new_row = List[Int]()
        for _ in range(cols):
            new_row.append(NOT_CALCULATED)
        res.append(new_row)
    
    var q = List[Pos]()

    # scan for thieves
    for r in range(rows):
        for c in range(cols):
            if grid[r][c] == 1:
                res[r][c] = 0
                q.append(Pos(r, c))
    
    while q:
        var p = q.pop(0)

        var safety_score = res[p.row][p.col]

        for dir in dirs:
            var new_pos = Pos(
                p.row + dir[][0],
                p.col + dir[][1],
            )

            if (
                0 <= new_pos.row < rows # row index is valid
                and 0 <= new_pos.col < cols # col index is valid
                and res[new_pos.row][new_pos.col] == NOT_CALCULATED
            ):
                res[new_pos.row][new_pos.col] = safety_score + 1
                q.append(new_pos)
    return res

@value
struct Cell(heap.HeapableCollectionElement):
    var pos: Pos
    var safety_score: Int

    fn __lt__(self, rhs: Cell) -> Bool:
        """ Compare two cells based on their safety scores. The "lowest" (i.e., first priority for 
            the heap to return on a pop-operation) is the cell with the highest safety score.
            In other words, this is a "max-heap" implementation.
        """
        return self.safety_score > rhs.safety_score


fn maximum_safeness_factor(grid: List[List[Int]]) raises -> Int:
    """ Calculate the maximum safeness factor of all paths leading
        from the upper-left (cell 0,0) to the lower-right (cell n-1, n-1).
    """
    if grid[0][0] or grid[-1][-1]:
        return 0
    var safety_scores = calc_manhattan_dist_to_thief(grid)

    # TODO: convert to a list-comprehension, when supported in Mojo
    var visited = List[List[Bool]]()
    for _ in grid:
        var new_row = List[Bool]()
        for _ in range(len(grid[0])):
            new_row.append(False)
        visited.append(new_row)
    
    var pq = List[Cell]()
    pq.append(Cell(
        Pos(0, 0),
        safety_scores[0][0],
    ))
    heap.heapify(pq)

    while pq:
        var cell = heap.pop(pq)

        if cell.pos.row == len(grid) - 1 and cell.pos.col == len(grid[0]) - 1:
            return cell.safety_score
        
        visited[cell.pos.row][cell.pos.col] = True

        for dir in dirs:
            var new_pos = Pos(
                cell.pos.row + dir[][0],
                cell.pos.col + dir[][1],
            )

            if (
                0 <= new_pos.row < len(grid) # row index is valid
                and 0 <= new_pos.col < len(grid[0]) # col index is valid
                and not visited[new_pos.row][new_pos.col]
            ):
                var new_safety_score = min(
                    cell.safety_score,
                    safety_scores[new_pos.row][new_pos.col],
                )
                heap.push(pq, Cell(new_pos, new_safety_score))
                visited[new_pos.row][new_pos.col] = True
    
    return -1


""" Test cases come from LeetCode 2812: Find the Safest Path in a Grid
    https://leetcode.com/problems/find-the-safest-path-in-a-grid

    You are given a 0-indexed 2D matrix grid of size n x n, where (r, c) represents:
        A cell containing a thief if grid[r][c] = 1
        An empty cell if grid[r][c] = 0
    
    You are initially positioned at cell (0, 0). In one move, you can move to any adjacent cell in
    the grid, including cells containing thieves.

    The safeness factor of a path on the grid is defined as the minimum manhattan distance from any
    cell in the path to any thief in the grid.

    Return the maximum safeness factor of all paths leading to cell (n - 1, n - 1).

    An adjacent cell of cell (r, c), is one of the cells (r, c + 1), (r, c - 1), (r + 1, c) and 
    (r - 1, c) if it exists.

    The Manhattan distance between two cells (a, b) and (x, y) is equal to |a - x| + |b - y|, 
    where |val| denotes the absolute value of val.
"""
def test_heap_dijkstra_shortest_path_case_1():
    """ TEST CASE 1
        Input: grid = [[1,0,0],[0,0,0],[0,0,1]]
        Output: 0
        Explanation: All paths from (0, 0) to (n - 1, n - 1) go through the thieves in cells (0, 0) 
        and (n - 1, n - 1).
    """
    var grid = List(List(1, 0, 0), List(0, 0, 0), List(0, 0, 1))

    var got = maximum_safeness_factor(grid)
    var want = 0
    assert_equal(got, want)

def test_heap_dijkstra_shortest_path_case_2():
    """ TEST CASE 2
        Input: grid = [[0,0,1],[0,0,0],[0,0,0]]
        Output: 2
        Explanation: The path depicted in the picture above has a safeness factor of 2 since:
            - The closest cell of the path to the thief at cell (0, 2) is cell (0, 0). The distance
              between them is | 0 - 0 | + | 0 - 2 | = 2.
        It can be shown that there are no other paths with a higher safeness factor.
    """
    var grid = List(List(0, 0, 1), List(0, 0, 0), List(0, 0, 0))
    var got = maximum_safeness_factor(grid)
    var want = 2
    assert_equal(got, want)

def test_heap_dijkstra_shortest_path_case_3():
    """ TEST CASE 3
        Input: grid = [[0,0,0,1],[0,0,0,0],[0,0,0,0],[1,0,0,0]]
        Output: 2
        Explanation: The path depicted in the picture above has a safeness factor of 2 since:
            - The closest cell of the path to the thief at cell (0, 3) is cell (1, 2). The distance 
              between them is | 0 - 1 | + | 3 - 2 | = 2.
            - The closest cell of the path to the thief at cell (3, 0) is cell (3, 2). The distance 
              between them is | 3 - 3 | + | 0 - 2 | = 2.
        It can be shown that there are no other paths with a higher safeness factor.
    """
    var grid = List(List(0, 0, 0, 1), List(0, 0, 0, 0), List(1, 0, 0, 0))
    var got = maximum_safeness_factor(grid)
    var want = 2
    assert_equal(got, want)

# TODO: remove this main; I just put it here so I can quickly run single test case manually while debugging
def main():
    test_heap_dijkstra_shortest_path_case_1()
    # test_heap_dijkstra_shortest_path_case_2()
    # test_heap_dijkstra_shortest_path_case_3()