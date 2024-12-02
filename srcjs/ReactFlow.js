import { Fragment, useCallback } from 'react';

import {
  ReactFlow as ReactFlowOrig,
  useNodesState,
  useEdgesState,
  addEdge,
  MiniMap,
  Controls,
  Background,
  BackgroundVariant,
} from '@xyflow/react';


import '@xyflow/react/dist/style.css';


export default function ReactFlow({
  nodes,
  edges,
  controls,
  background,
  miniMap,
  ...props
}) {
  const [final_nodes, setNodes, onNodesChange] = useNodesState(nodes);
  const [final_edges, setEdges, onEdgesChange] = useEdgesState(edges);
  
  // TODO allow MiniMap, Controls, Background to be passed as props
  
  // TODO make optional
  // TODO make onNodeChange, onEdgeChange, onConnect a JS function that can be passed
  const onConnect = useCallback((params) => setEdges((eds) => addEdge(params, eds)), [setEdges]);

  // console.log(onEdgesChange);
  console.log("Hi from ReactFlow component!");
  
  
  return (
    <ReactFlowOrig
      nodes={final_nodes}
      edges={final_edges}
      onNodesChange={onNodesChange}
      onEdgesChange={onEdgesChange}
      onConnect={onConnect}
      {...props}
    >
      MiniMap: {miniMap},
      Controls: {controls},
      Background: {background}
    </ReactFlowOrig>
  )
}
