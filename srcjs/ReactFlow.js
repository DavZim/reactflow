import React, { memo, Fragment, useCallback } from 'react';

import {
  ReactFlow as ReactFlowOrig,
  useNodesState,
  useEdgesState,
  addEdge,
//  MiniMap,
//  Controls,
//  Background,
  BackgroundVariant,
  Handle,
  Position,
  useReactFlow,
} from '@xyflow/react';

import dagre from '@dagrejs/dagre';

import '@xyflow/react/dist/style.css';

function HTMLNode({ data }) {
  return (
    <>
      <div dangerouslySetInnerHTML={{ __html: data.html }}></div>
    
      <Handle
        type="target"
        position={Position.Top}
      />
      <Handle
        type="source"
        position={Position.Bottom}
      />
    </>
  );
}

const nodeTypes = {
  html: HTMLNode
};




// dagre wrapper function
const getLayoutedNodes = (innodes, inedges, direction = 'TB', config) => {
  const dagreGraph = new dagre.graphlib.Graph().setDefaultEdgeLabel(() => ({}));
  const isHorizontal = direction === 'LR';
  dagreGraph.setGraph({ rankdir: direction });
 
  innodes.forEach((node) => {
    dagreGraph.setNode(node.id, { width: config.nodeWidth, height: config.nodeHeight });
  });
 
  inedges.forEach((edge) => {
    dagreGraph.setEdge(edge.source, edge.target);
  });
 
  dagre.layout(dagreGraph);
 
  const newNodes = innodes.map((node) => {
    const nodeWithPosition = dagreGraph.node(node.id);
    const newNode = {
      ...node,
      targetPosition: isHorizontal ? 'left' : 'top',
      sourcePosition: isHorizontal ? 'right' : 'bottom',
      // We are shifting the dagre node position (anchor=center center) to the top left
      // so it matches the React Flow node anchor point (top left).
      position: {
        x: nodeWithPosition.x - config.nodeWidth / 2,
        y: nodeWithPosition.y - config.nodeHeight / 2,
      },
    };
    return newNode;
  });
 
  return newNodes;
};

export default function ReactFlow({
  elementId,
  nodes,
  edges,
  allow_edge_connection,
  use_dagre, dagre_direction, dagre_config,
  ...props
}) {
  
  // if dagre is enabled, we need to layout the nodes
  if (use_dagre) {
    // Overwrite nodes with layouted nodes
    nodes = getLayoutedNodes(nodes, edges, dagre_direction, dagre_config);
  }
    
  const [final_nodes, setNodes, onNodesChange] = useNodesState(nodes);
  const [final_edges, setEdges, onEdgesChange] = useEdgesState(edges);
  
  // TODO make onNodeChange, onEdgeChange, onConnect a JS function that can be passed ?? 

  const onConnect = useCallback((params) => setEdges((eds) => addEdge(params, eds)), [setEdges]);

  // for the minimap
  function nodeColor(node) {
    switch (node.type) {
      case 'input':
        return 'lightgreen';
      case 'output':
        return 'coral';
      default:
        return 'lightblue';
    }
  }
    
  // when the layout changes, recalculate the positions
  const onLayout = useCallback(
    (dagre_direction) => {
      nodes2 = getLayoutedNodes(nodes, edges, dagre_direction, dagre_config);
  
      setNodes([...nodes2]);
      setEdges([...edges]);
      
      window.requestAnimationFrame(() => {
        fitView();
      });
      
    },
    [nodes, edges, dagre_direction, dagre_config],
  );
  
  return (
    <ReactFlowOrig
      nodes={final_nodes}
      edges={final_edges}
      onNodesChange={onNodesChange}
      onEdgesChange={onEdgesChange}
      onLayout={onLayout}
      onConnect={allow_edge_connection ? onConnect : undefined}
      nodeTypes={nodeTypes}
      
      onNodeDrag={(event, node, nodes) => {
        Shiny.setInputValue(elementId + "_click", {node: node.id, edge: null});
      }}
      onNodeClick={(event, node) => {
        Shiny.setInputValue(elementId + "_click", {node: node.id, edge: null});
      }}
      onEdgeClick={(event, edge) => {
        Shiny.setInputValue(elementId + "_click", {node: null, edge: edge.id});
      }}
      {...props}
    >
    </ReactFlowOrig>
  )
}
