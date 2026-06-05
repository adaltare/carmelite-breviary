package main

import (
	"fmt"
	"os"
	"strings"
)

// BlockType represents the type of transformation for a block.
type BlockType string

const (
	Ins  BlockType = "ins"
	Del  BlockType = "del"
	Sub  BlockType = "sub"
	Mov  BlockType = "mov"
	Inv  BlockType = "inv"
	None BlockType = "none"
)

// Block represents a typed decorated block as formalized in the MEDITE algorithm.
type Block struct {
	Type       BlockType
	Begin      int
	End        int
	Decorators []Block // Moved sub-blocks acting as decorators
	Text       string
}

// BiBlock represents an alignment between two blocks from sequences s1 and s2.
type BiBlock struct {
	S1 *Block
	S2 *Block
}

// MEDITEAlign orchestrates the two phases of the MEDITE algorithm.
func MEDITEAlign(s1, s2 string) []BiBlock {
	// Default minimum size parameter for homologies is 5 characters.
	minAnchorSize := 5

	// Phase 1: Block Permutation Problem
	invariants, moves := phaseOneBlockPermutation(s1, s2, minAnchorSize)

	// Default ratios for substitutions and split evaluations are set to 0.5.
	subRatio := 0.5
	splitRatio := 0.5

	// Phase 2: Bi-block List Building
	return phaseTwoBiBlockBuilding(s1, s2, invariants, moves, subRatio, splitRatio)
}

// phaseOneBlockPermutation handles suffix tree generation, overlap resolution, and A* alignment.
func phaseOneBlockPermutation(s1, s2 string, minSize int) (invariants []Block, moves []Block) {
	// Step 1: Find Anchors
	homologies := extractHomologies(s1, s2, minSize)

	// Step 2: Resolve Overlaps
	disjointBlocks := resolveOverlaps(homologies)

	// Step 3: A* Search for Alignment
	invariants, moves = aStarAlignment(disjointBlocks, s1, s2)

	// Step 4: Recursive Processing
	invariants, moves = recursiveProcess(invariants, moves, s1, s2, minSize)

	return invariants, moves
}

// recursiveProcess recursively aligns subsequences between invariant blocks.
func recursiveProcess(invariants, moves []Block, s1, s2 string, minSize int) ([]Block, []Block) {
	// For each pair of consecutive invariant blocks, recursively align the subsequences between them
	for i := 0; i < len(invariants)-1; i++ {
		inv1 := invariants[i]
		inv2 := invariants[i+1]

		// Extract subsequences between invariant blocks
		subS1Start := inv1.End
		subS1End := inv2.Begin
		subS2Start := inv1.End
		subS2End := inv2.Begin

		if subS1Start < subS1End && subS2Start < subS2End {
			subS1 := s1[subS1Start:subS1End]
			subS2 := s2[subS2Start:subS2End]

			// Recursively process only if subsequences are non-trivial
			if len(subS1) > 0 && len(subS2) > 0 {
				subInvariants, subMoves := phaseOneBlockPermutation(subS1, subS2, minSize)

				// Adjust indices and append to result lists
				for _, inv := range subInvariants {
					inv.Begin += subS1Start
					inv.End += subS1Start
					invariants = append(invariants, inv)
				}
				for _, mov := range subMoves {
					mov.Begin += subS1Start
					mov.End += subS1Start
					moves = append(moves, mov)
				}
			}
		}
	}

	return invariants, moves
}

// phaseTwoBiBlockBuilding constructs the final alignment lists and applies substitution/split heuristics.
func phaseTwoBiBlockBuilding(s1, s2 string, invariants, moves []Block, subRatio, splitRatio float64) []BiBlock {
	var biBlockList []BiBlock

	// Sort invariants by position for consistent processing
	sortBlocks(invariants)
	sortBlocks(moves)

	// 1. Identify deleted (del) and inserted (ins) blocks between invariants.
	biBlockList = identifyDeletionsAndInsertions(s1, s2, invariants)

	// 2. Assign moved blocks as decorators to overlapping del or ins blocks.
	biBlockList = assignMovedDecorators(biBlockList, moves)

	// 3. Apply Heuristic 1: Substitution merging
	biBlockList = applySubstitutionHeuristic(biBlockList, subRatio)

	// 4. Apply Heuristic 2: Decorator splitting
	biBlockList = applySplitHeuristic(biBlockList, splitRatio)

	return biBlockList
}

// sortBlocks sorts blocks by their beginning position.
func sortBlocks(blocks []Block) {
	for i := 0; i < len(blocks)-1; i++ {
		for j := i + 1; j < len(blocks); j++ {
			if blocks[j].Begin < blocks[i].Begin {
				blocks[i], blocks[j] = blocks[j], blocks[i]
			}
		}
	}
}

// identifyDeletionsAndInsertions identifies del and ins blocks between invariants.
func identifyDeletionsAndInsertions(s1, s2 string, invariants []Block) []BiBlock {
	var biBlockList []BiBlock

	if len(invariants) == 0 {
		// If no invariants found, the entire sequences are substitutions/deletions/insertions
		return []BiBlock{{
			S1: &Block{Type: Del, Text: s1, Begin: 0, End: len(s1)},
			S2: &Block{Type: Ins, Text: s2, Begin: 0, End: len(s2)},
		}}
	}

	prevEnd1 := 0
	prevEnd2 := 0

	for _, inv := range invariants {
		// Add invariant block itself
		biBlockList = append(biBlockList, BiBlock{
			S1: &Block{Type: Inv, Begin: inv.Begin, End: inv.End, Text: s1[inv.Begin:inv.End]},
			S2: &Block{Type: Inv, Begin: inv.Begin, End: inv.End, Text: s2[inv.Begin:inv.End]},
		})

		// Add deletion and insertion blocks between invariants
		if inv.Begin > prevEnd1 {
			delBlock := &Block{
				Type:  Del,
				Begin: prevEnd1,
				End:   inv.Begin,
				Text:  s1[prevEnd1:inv.Begin],
			}
			insBlock := &Block{
				Type:  Ins,
				Begin: prevEnd2,
				End:   inv.Begin,
				Text:  s2[prevEnd2:inv.Begin],
			}
			biBlockList = append(biBlockList, BiBlock{S1: delBlock, S2: insBlock})
		}

		prevEnd1 = inv.End
		prevEnd2 = inv.End
	}

	// Handle remaining text after last invariant
	if prevEnd1 < len(s1) || prevEnd2 < len(s2) {
		delBlock := &Block{
			Type:  Del,
			Begin: prevEnd1,
			End:   len(s1),
			Text:  s1[prevEnd1:],
		}
		insBlock := &Block{
			Type:  Ins,
			Begin: prevEnd2,
			End:   len(s2),
			Text:  s2[prevEnd2:],
		}
		biBlockList = append(biBlockList, BiBlock{S1: delBlock, S2: insBlock})
	}

	return biBlockList
}

// assignMovedDecorators assigns moved blocks as decorators to overlapping del/ins blocks.
func assignMovedDecorators(biBlockList []BiBlock, moves []Block) []BiBlock {
	for i := range biBlockList {
		for _, mov := range moves {
			// Check if move overlaps with deletion
			if biBlockList[i].S1 != nil && biBlockList[i].S1.Type == Del {
				if mov.Begin >= biBlockList[i].S1.Begin && mov.Begin < biBlockList[i].S1.End {
					biBlockList[i].S1.Decorators = append(biBlockList[i].S1.Decorators, mov)
				}
			}
			// Check if move overlaps with insertion
			if biBlockList[i].S2 != nil && biBlockList[i].S2.Type == Ins {
				if mov.Begin >= biBlockList[i].S2.Begin && mov.Begin < biBlockList[i].S2.End {
					biBlockList[i].S2.Decorators = append(biBlockList[i].S2.Decorators, mov)
				}
			}
		}
	}
	return biBlockList
}

// applySubstitutionHeuristic merges adjacent del/ins pairs into substitutions.
func applySubstitutionHeuristic(list []BiBlock, threshold float64) []BiBlock {
	var result []BiBlock
	i := 0

	for i < len(list) {
		// Look for del followed by ins pattern
		if i+1 < len(list) {
			curr := list[i]
			next := list[i+1]

			isDel := curr.S1 != nil && curr.S1.Type == Del && (curr.S2 == nil || curr.S2.Type == Ins)
			isIns := next.S1 != nil && next.S1.Type == Ins && (next.S2 == nil || next.S2.Type == Ins)

			if isDel && isIns {
				delSize := float64(curr.S1.End - curr.S1.Begin)
				insSize := float64(next.S2.End - next.S2.Begin)

				// Calculate ratio
				maxSize := delSize
				if insSize > maxSize {
					maxSize = insSize
				}

				if maxSize > 0 {
					ratio := delSize / maxSize
					if ratio >= threshold {
						// Merge into substitution
						subBlock := BiBlock{
							S1: &Block{Type: Sub, Begin: curr.S1.Begin, End: curr.S1.End, Text: curr.S1.Text},
							S2: &Block{Type: Sub, Begin: next.S2.Begin, End: next.S2.End, Text: next.S2.Text},
						}
						result = append(result, subBlock)
						i += 2
						continue
					}
				}
			}
		}

		result = append(result, list[i])
		i++
	}

	return result
}

// applySplitHeuristic splits heavily decorated blocks into mov types.
func applySplitHeuristic(list []BiBlock, threshold float64) []BiBlock {
	var result []BiBlock

	for _, biBlock := range list {
		if biBlock.S1 != nil && (biBlock.S1.Type == Del || biBlock.S1.Type == Ins) && len(biBlock.S1.Decorators) > 0 {
			blockSize := float64(biBlock.S1.End - biBlock.S1.Begin)
			decoratorSize := 0.0

			for _, dec := range biBlock.S1.Decorators {
				decoratorSize += float64(dec.End - dec.Begin)
			}

			if blockSize > 0 {
				ratio := decoratorSize / blockSize
				if ratio >= threshold {
					// Convert type to mov
					if biBlock.S1.Type == Del {
						biBlock.S1.Type = Mov
					}
					if biBlock.S2 != nil && biBlock.S2.Type == Ins {
						biBlock.S2.Type = Mov
					}
				}
			}
		}

		result = append(result, biBlock)
	}

	return result
}

// --- Helper Functions ---

// extractHomologies finds maximal exact matches (homologies) of at least minSize.
func extractHomologies(s1, s2 string, minSize int) []Block {
	var homologies []Block
	seen := make(map[string]bool)

	// Brute-force approach: find all common substrings of at least minSize
	for i := 0; i < len(s1); i++ {
		for j := i + minSize; j <= len(s1); j++ {
			substr := s1[i:j]

			// Find this substring in s2
			if idx := strings.Index(s2, substr); idx != -1 && !seen[substr] {
				homologies = append(homologies, Block{
					Type:  Inv,
					Begin: i,
					End:   j,
					Text:  substr,
				})
				seen[substr] = true
				break // Take only the first (longest) match to avoid duplicates
			}
		}
	}

	return homologies
}

// resolveOverlaps removes overlapping blocks, preferring longer blocks and cuts on separators.
func resolveOverlaps(blocks []Block) []Block {
	if len(blocks) == 0 {
		return blocks
	}

	// Sort by begin position, then by size (descending)
	for i := 0; i < len(blocks)-1; i++ {
		for j := i + 1; j < len(blocks); j++ {
			if blocks[j].Begin < blocks[i].Begin ||
				(blocks[j].Begin == blocks[i].Begin && (blocks[j].End-blocks[j].Begin) > (blocks[i].End-blocks[i].Begin)) {
				blocks[i], blocks[j] = blocks[j], blocks[i]
			}
		}
	}

	var result []Block
	for _, block := range blocks {
		overlaps := false
		for _, existing := range result {
			// Check for overlap
			if !(block.End <= existing.Begin || block.Begin >= existing.End) {
				overlaps = true
				break
			}
		}
		if !overlaps {
			result = append(result, block)
		}
	}

	return result
}

// aStarAlignment performs a simple greedy alignment of blocks to maximize invariants.
func aStarAlignment(blocks []Block, s1, s2 string) ([]Block, []Block) {
	var invariants []Block
	var moves []Block

	// Simple greedy approach: select non-overlapping blocks that appear in order
	used := make(map[int]bool)

	for _, block := range blocks {
		canUse := true
		for _, existing := range invariants {
			if !(block.End <= existing.Begin || block.Begin >= existing.End) {
				canUse = false
				break
			}
		}

		if canUse {
			invariants = append(invariants, block)
			used[block.Begin] = true
		} else {
			moves = append(moves, block)
		}
	}

	return invariants, moves
}

// escapeGraphviz escapes special characters for GraphViz labels.
func escapeGraphviz(text string) string {
	result := ""
	for _, ch := range text {
		switch ch {
		case '"':
			result += "\\\""
		case '\\':
			result += "\\\\"
		case '\n':
			result += "\\n"
		case '\t':
			result += "\\t"
		default:
			result += string(ch)
		}
	}
	return result
}

// printGraphViz outputs the alignment as a GraphViz digraph.
func printGraphViz(s1, s2 string, alignment []BiBlock) {
	fmt.Println("digraph G {")
	fmt.Println("  rankdir=LR;")
	fmt.Println("  node [shape=box];")

	// Build node list
	nodeID := 0
	nodeMap := make(map[string]int) // Maps "s1_begin_end" or "s2_begin_end" to node ID

	// Start node (empty)
	fmt.Printf("  v%d [label = \"\"];\n", nodeID)
	startNode := nodeID
	nodeID++

	// Create nodes for all blocks and assign IDs
	nodeOrder := make([]struct {
		id       int
		isS1     bool
		isS2     bool
		text     string
		biBlock  int // index in alignment
	}, 0)

	for i, biBlock := range alignment {
		if biBlock.S1 != nil {
			key := fmt.Sprintf("s1_%d_%d", biBlock.S1.Begin, biBlock.S1.End)
			if _, exists := nodeMap[key]; !exists {
				nodeMap[key] = nodeID
				nodeOrder = append(nodeOrder, struct {
					id       int
					isS1     bool
					isS2     bool
					text     string
					biBlock  int
				}{nodeID, true, false, biBlock.S1.Text, i})
				nodeID++
			}
		}
		if biBlock.S2 != nil {
			key := fmt.Sprintf("s2_%d_%d", biBlock.S2.Begin, biBlock.S2.End)
			if _, exists := nodeMap[key]; !exists {
				nodeMap[key] = nodeID
				nodeOrder = append(nodeOrder, struct {
					id       int
					isS1     bool
					isS2     bool
					text     string
					biBlock  int
				}{nodeID, false, true, biBlock.S2.Text, i})
				nodeID++
			}
		}
	}

	// End node (empty)
	endNode := nodeID
	fmt.Printf("  v%d [label = \"\"];\n", endNode)
	nodeID++

	// Print node labels
	for _, node := range nodeOrder {
		escapedText := escapeGraphviz(node.text)
		fmt.Printf("  v%d [label = \"%s\"];\n", node.id, escapedText)
	}

	// Create edges from start to first blocks
	var prevS1ID, prevS2ID int
	firstS1Set, firstS2Set := false, false

	for _, biBlock := range alignment {
		if biBlock.S1 != nil && !firstS1Set {
			key := fmt.Sprintf("s1_%d_%d", biBlock.S1.Begin, biBlock.S1.End)
			prevS1ID = nodeMap[key]
			firstS1Set = true
		}
		if biBlock.S2 != nil && !firstS2Set {
			key := fmt.Sprintf("s2_%d_%d", biBlock.S2.Begin, biBlock.S2.End)
			prevS2ID = nodeMap[key]
			firstS2Set = true
		}
	}

	if firstS1Set && firstS2Set && prevS1ID == prevS2ID {
		fmt.Printf("  v%d -> v%d [label = \"W1, W2\"];\n", startNode, prevS1ID)
	} else {
		if firstS1Set {
			fmt.Printf("  v%d -> v%d [label = \"W1\"];\n", startNode, prevS1ID)
		}
		if firstS2Set {
			fmt.Printf("  v%d -> v%d [label = \"W2\"];\n", startNode, prevS2ID)
		}
	}

	// Create edges between consecutive blocks on S1 and S2 paths
	for _, biBlock := range alignment {
		if biBlock.S1 != nil {
			currKey := fmt.Sprintf("s1_%d_%d", biBlock.S1.Begin, biBlock.S1.End)
			currID := nodeMap[currKey]

			if prevS1ID != 0 && prevS1ID != currID {
				fmt.Printf("  v%d -> v%d [label = \"W1\"];\n", prevS1ID, currID)
			}
			prevS1ID = currID
		}

		if biBlock.S2 != nil {
			currKey := fmt.Sprintf("s2_%d_%d", biBlock.S2.Begin, biBlock.S2.End)
			currID := nodeMap[currKey]

			if prevS2ID != 0 && prevS2ID != currID {
				fmt.Printf("  v%d -> v%d [label = \"W2\"];\n", prevS2ID, currID)
			}
			prevS2ID = currID
		}
	}

	// Create edges to end node
	if prevS1ID != 0 {
		fmt.Printf("  v%d -> v%d [label = \"W1\"];\n", prevS1ID, endNode)
	}
	if prevS2ID != 0 && prevS2ID != prevS1ID {
		fmt.Printf("  v%d -> v%d [label = \"W2\"];\n", prevS2ID, endNode)
	}

	// Draw alignment edges between matching blocks (dashed)
	for _, biBlock := range alignment {
		if biBlock.S1 != nil && biBlock.S2 != nil && biBlock.S1.Type == Inv && biBlock.S2.Type == Inv {
			key1 := fmt.Sprintf("s1_%d_%d", biBlock.S1.Begin, biBlock.S1.End)
			key2 := fmt.Sprintf("s2_%d_%d", biBlock.S2.Begin, biBlock.S2.End)
			id1 := nodeMap[key1]
			id2 := nodeMap[key2]

			if id1 != id2 {
				fmt.Printf("  v%d -> v%d [color = \"lightgray\", style = \"dashed\", arrowhead = \"none\", arrowtail = \"none\"];\n", id1, id2)
			}
		}
	}

	// Invisible edge from start to end for graph structure
	fmt.Printf("  v%d -> v%d [color = \"white\"];\n", startNode, endNode)

	fmt.Println("}")
}

func main() {
	s1 := "This is the way the world runs."
	s2 := "This is the world in the way it runs."

	fmt.Fprintf(os.Stderr, "Starting MEDITE Alignment...\n")
	alignment := MEDITEAlign(s1, s2)
	fmt.Fprintf(os.Stderr, "Produced %d Bi-blocks in the alignment.\n\n", len(alignment))

	// Print alignment details to stderr
	for i, biBlock := range alignment {
		fmt.Fprintf(os.Stderr, "Bi-block %d:\n", i+1)
		if biBlock.S1 != nil {
			fmt.Fprintf(os.Stderr, "  S1: Type=%s, Text='%s' (pos %d-%d)\n", biBlock.S1.Type, biBlock.S1.Text, biBlock.S1.Begin, biBlock.S1.End)
			if len(biBlock.S1.Decorators) > 0 {
				fmt.Fprintf(os.Stderr, "      Decorators: %d\n", len(biBlock.S1.Decorators))
			}
		}
		if biBlock.S2 != nil {
			fmt.Fprintf(os.Stderr, "  S2: Type=%s, Text='%s' (pos %d-%d)\n", biBlock.S2.Type, biBlock.S2.Text, biBlock.S2.Begin, biBlock.S2.End)
			if len(biBlock.S2.Decorators) > 0 {
				fmt.Fprintf(os.Stderr, "      Decorators: %d\n", len(biBlock.S2.Decorators))
			}
		}
		fmt.Fprintf(os.Stderr, "\n")
	}

	// Print GraphViz output to stdout
	printGraphViz(s1, s2, alignment)
}
