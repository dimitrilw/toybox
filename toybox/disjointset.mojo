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
	""" DisjointSet represents a Disjoint Set (aka Union Find). """
	var parents: List[Int]
	var ranks: List[Int]
	var sizes: List[Int]
	var num_sets: Int


	fn __init__(inout self, size: Int = 0):
		""" Initializes a new DisjointSet with `size` elements and IDs 0 to `size - 1`. 

			Args:
				size: Optional. The number of elements to initialize the DisjointSet with. Default = 0.
		"""
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
	
	fn set_ids(self) -> List[Int]:
		""" Returns a list of set IDs where each ID is the parent node. """
		var res = List[Int]()
		for i in range(len(self.parents)):
			if self.parents[i] == i:
				res.append(i)
		return res
	
	fn find(inout self, id: Int) -> Int:
		""" Returns the root element of the set containing the given element. """
		if not self.is_valid(id):
			return -1
		if self.parents[id] != id:
			self.parents[id] = self.find(self.parents[id])
		return self.parents[id]
	
	fn union(inout self, fromID: Int, destID: Int) -> Bool:
		""" Union performs the union of two sets containing given elements
			and returns true/false on whether or not a union action was completed.
			If the two elements are already in the same set, then no union is performed.
		"""
		var fID = self.find(fromID)
		var dID = self.find(destID)
		if fID == dID:
			# from ID is already in destination ID, or vice-versa
			return False
		if self.ranks[fID] == self.ranks[dID]:
			self.ranks[dID] += 1
		if self.ranks[dID] < self.ranks[fID]:
			# fromID is the higher-ranked ID; flip them
			fID, dID = dID, fID
		self.parents[fID] = dID
		self.sizes[dID] += self.sizes[fID]
		self.num_sets -= 1
		return True

	fn size(inout self, id: Int) -> Int:
		""" Returns the size of the set containing the given element. """
		if not self.is_valid(id):
			return 0
		return self.sizes[self.find(id)]