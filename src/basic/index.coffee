import { buildMapping } from "./mapping"
import _queryCombinators from "./query"

# Basic model supports get, put, delete. No partial updates. Queries and scans 
# enjoy only basic support.
Basic = (metal, context) ->
  (model) ->
    { mapKey, wrap, unwrap } = buildMapping model

    get: (key, options) ->
      { Item } = await metal.get ( mapKey key ), options
      if Item? then unwrap Item else undefined
      
    put: (data) -> 
      await metal.put ( wrap data ), options
      data
    
    delete: (key, options) ->
      await metal.delete ( mapKey key ), options
      undefined
      
    query: (options) -> 
      { Items, LastEvaluatedKey } = await metal.query options
      
      results: ( unwrap item for item in Items )
      next: LastEvaluatedKey

    scan: (options) -> 
      { Items, LastEvaluatedKey } = await metal.scan options
      
      results: ( unwrap item for item in Items )
      next: LastEvaluatedKey

    queryCombinators: _queryCombinators { wrap }

export default Basic