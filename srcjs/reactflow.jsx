import { ReactFlow, MiniMap, Controls, Background } from '@xyflow/react';
import '@xyflow/react/dist/style.css';

import { reactWidget } from 'reactR';

reactWidget('reactflow', 'output', {
  ReactFlow: ReactFlow,
  MiniMap: MiniMap,
  Controls: Controls,
  Background: Background
});