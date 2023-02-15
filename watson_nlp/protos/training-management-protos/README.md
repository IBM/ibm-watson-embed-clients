# model-mesh-protos
Protocol-buffer service definitions for training management gRPC APIs.

- [model-mesh.proto](model-mesh.proto) - Exposed by model-mesh, used by external clients to manage models/vmodels in a logical model-mesh cluster
- [model-runtime.proto](model-runtime.proto) - _Implemented_ by model runtime containers (deployed alongside model-mesh in the same pod), consumed by model-mesh

