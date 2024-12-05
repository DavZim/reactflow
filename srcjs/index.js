import { reactWidget } from 'reactR'

import ReactFlow from './ReactFlow'

import {
  MiniMap,
  Controls,
  Background
} from '@xyflow/react'


reactWidget('reactflow', 'output', {
  ReactFlow, MiniMap, Controls, Background
})


export * from './ReactFlow'
