//
//  pageRank.swift
//  pageRank
//
//  Created by Justin Purnell on 6/1/17.
//
//

import Foundation

public class Vertex {
	var key: String?
	var rank: Double
	var neighbors: [Edge]
	
	init() {
		self.neighbors = [Edge]()
		rank = 0;
	}
}

public class Edge {
	var neighbor: Vertex
	var weight: Int
	
	init() {
		weight = 1
		self.neighbor = Vertex()
	}
}

class Path {
	var total: Int!
	var destination: Vertex
	var previous: Path!
	
	init() {
		destination = Vertex()
	}
}

public class SwiftGraph {
	private var canvas: [Vertex]
	public var isDirected: Bool
	
	init() {
		canvas = [Vertex]()
		isDirected = true
	}
	
	//create a new vertex
	func addVertex(key: String) -> Vertex {
		let child: Vertex = Vertex()
		child.key = key
		//add the vertex to the graph canvas
		canvas.append(child)
		return child
	}
	
	func addEdge(source: Vertex, neighbor: Vertex, weight: Int) {
		//create a new edge
		let newEdge = Edge()
		//establish the default properties
		newEdge.neighbor = neighbor
		newEdge.weight = weight
		source.neighbors.append(newEdge)
		//check for undirected graph
		if (isDirected == false) {
			//create a new reversed edge
			let reverseEdge = Edge()
			//establish the reversed properties
			reverseEdge.neighbor = source
			reverseEdge.weight = weight
			neighbor.neighbors.append(reverseEdge)
		}
	}
	
	func calculatePageRankVertices(){
		// Calculation per https://en.wikipedia.org/wiki/PageRank#Damping_factor
		// 1) Count the vertices and returns the value,
		// 2) Initialize vertices to the same page rank (1/N where N is the number of vertices),
		// 3) Loop through the vertices X times, calculating their page rank with damping factor(d)= 0.85
		// 4) PR(A)=(1-d)/N + d (PR(B)/L(B) + PR(C)/L(C) + …
		
		let damping = 0.85;
		let numberOfVertices: Double = Double(canvas.count);
		for (vertex) in canvas {
			vertex.rank = 1/numberOfVertices;
		}
		print("Vertices: ", numberOfVertices);
		for _ in 0 ..< 100 {
			for vertex in canvas {
				var inbound: Double = 0;
				for vertex2 in canvas {
					let matrix: Double = Double(vertex2.neighbors.count);
					for (edge) in vertex2.neighbors {
						if(edge.neighbor === vertex) {
							inbound += vertex2.rank / matrix;
						}
					}
				}
				vertex.rank =  (1 - damping) / numberOfVertices + damping * inbound;
			}
		}
		print("Rank of Vertices: \n");
		for vertex in canvas {
			print("\(String(describing: vertex.key))\t\(vertex.rank)");
		}
	}
}
