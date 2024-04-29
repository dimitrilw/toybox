"""
A Disjoint Set (aka Union Find or DSU) data structure is commonly used for merging
sets of data as commonalities are found.

Example use:

	Here is a list of coordinates of interest. Add a new coordinate & if it is touching a neighbor,
	then merge them into one set. If it is touching multiple, merge them all, one-by-one.

	Find loops in a graph by trying to merge nodes & if `DisjointSet.Union()` returns `false`,
	then you know you hit a loop because they are already in the same set.

	Social network groups merging together into a single set.

...and more.

While Len, Size, and SetIDs are not typically used, they are provided for convenience.
I encounter the requirement to calculate these values often enough that I decided
to include them. The overhead is small.
"""

struct DisjointSet(Sized):
	""" DisjointSet represents a Disjoint Set (aka Union Find).

		Usage:
		# TODO: add usage examples
		```
	"""
	var parents: List[Int]
	var ranks: List[Int]
	var sizes: List[Int]
	var num_sets: Int


	fn __init__(inout self, size: Int = 0):
		""" Initializes a new DisjointSet with `size` elements and IDs 0 to `size - 1`. 

			Args:
				size: Optional. The number of elements to initialize the DisjointSet with. Default = 0.
		"""
		# TODO: implement sizing at time of allocation, not via appending
		self.parents = List[Int]()
		self.ranks = List[Int]()
		self.sizes = List[Int]()
		self.num_sets = size
		for i in range(size):
			self.parents.append(i)
			self.ranks.append(0)
			self.sizes.append(1)

	
	fn __len__(self) -> Int:
		""" Returns the number of sets in the DisjointSet. """
		return self.num_sets
	
	fn is_valid(self, id: Int) -> Bool:
		""" Checks if the given ID is a valid int for the DisjointSet's current state. """
		return 0 <= id < len(self.parents)
	
	fn add(inout self) -> Int:
		""" Adds a new element to the DisjointSet and returns that element's ID. """
		var id = len(self.parents)
		self.parents.append(id)
		self.ranks.append(0)
		self.sizes.append(1)
		self.num_sets += 1
		return id


""" TODO: implement the rest of the DisjointSet class

// SetIDs returns a list of set IDs where each ID is the parent node.
func (d *DisjointSet) SetIDs() []int {
	res := []int{}
	for i, p := range d.parents {
		if i == p {
			res = append(res, i)
		}
	}
	return res
}

// Find returns root element of set containing given element.
func (d *DisjointSet) Find(id int) int {
	if !d.IsValid(id) {
		return -1
	}
	if d.parents[id] != id {
		d.parents[id] = d.Find(d.parents[id])
	}
	return d.parents[id]
}

// Size returns size of set containing given element.
func (d *DisjointSet) Size(id int) int {
	if !d.IsValid(id) {
		return 0
	}

	return d.sizes[d.Find(id)]
}

/*
Union performs the union of two sets containing given elements
and returns true/false on whether or not a union action was completed.
If the two elements are already in the same set, then no union is performed.

The from/dest order is a matter of personal preference. I find that it makes
code line-up better when I use it like this:

	for pos := range listOfNewPositionsOfInterest {
		posID := d.Add()
		if pos.row == 0 {
			d.Union(posID, topGroupID)
		}
		if pos.row == numRows - 1 {
			d.Union(posID, bottomGroupID)
		}
		if pos.col == 0 {
			d.Union(posID, leftGroupID)
		}
		if pos.col == numCols - 1 {
			d.Union(posID, rightGroupID)
		}
	}

Granted, this assumes I ensure the first merge into the "dest" groups (top, bottom, left, right)
was done with that group's ID as the "dest" ID so that it has the highest rank. After that,
order doesn't matter as much. I just find it easier to read when I do it this way.
*/
func (d *DisjointSet) Union(fromID, destID int) bool {
	fromID = d.Find(fromID)
	destID = d.Find(destID)
	// from ID is already in destination ID ...or vice-versa
	if fromID == destID {
		return false
	}

	if d.ranks[fromID] == d.ranks[destID] {
		d.ranks[destID]++
	}

	if d.ranks[destID] < d.ranks[fromID] {
		// fromID is the higher-ranked ID.
		// User had from/dest flipped, and we'll merge anyway.
		fromID, destID = destID, fromID
	}
	d.parents[fromID] = destID
	d.sizes[destID] += d.sizes[fromID]
	d.numSets--
	return true
}
"""