
nodes <- list(
  list(id = "jd", position = list(x = 200, y = 50),
       data = list(label = "Jane Doe", title = "CEO", icon = "👩")),
  list(id = "tw", position = list(x = 0, y = 200),
       data = list(label = "Tyler Weary", title = "Designer", icon = "👨")),
  list(id = "kp", position = list(x = 400, y = 200),
       data = list(label = "Kristi Price", title = "Developer", icon = "👩"))
)
edges <- list(
  list(id = "jd-tw", source = "jd", target = "tw"),
  list(id = "jd-kp", source = "jd", target = "kp")
)


node_types <- JS(reactR::babel_transform('
import React, { memo } from "react";
import { Handle, Position } from "@xyflow/react";
 
function CustomNode({ data }) {
  return (
    <div className="container">
        <div className="emoji">
          {data.emoji}
        </div>
        <div className="text-element">
          <div className="text-name">{data.name}</div>
          <div className="text-job">{data.job}</div>
        </div>
      </div>
 
      <Handle
        type="target"
        position={Position.Top}
        className="handle"
      />
      <Handle
        type="source"
        position={Position.Bottom}
        className="handle"
      />
    </div>
  );
}
'))

reactflow(
  nodes,
  edges,
  mini_map(),
  controls(),
  background(),
  nodeTypes = node_types
)