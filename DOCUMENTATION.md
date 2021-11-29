# API

## Contentful

For a more detailed explanation of each method, lookup the [documentation for contentful.js](https://contentful.github.io/contentful.js)

### t
```rescript
type t
```

### makeClientOpts
```rescript
let makeClientOpts: (
  ~space: string,
  ~accessToken: string,
  ~environment: string=?,
  ~insecure: bool=?,
  ~host: string=?,
  ~basePath: string=?,
  ~httpAgent: 'httpAgent=?,
  ~httpsAgent: 'httpsAgent=?,
  ~proxy: axiosProxyConfig=?,
  ~headers: 'headers=?,
  ~adapter: 'adapter=?,
  ~application: string=?,
  ~integration: string=?,
  ~resolveLinks: bool=?,
  ~removeUnresolved: bool=?,
  ~retryOnError: bool=?,
  ~logHandler: (. clientLogLevel, option<'data>) => unit=?,
  ~timeout: int=?,
  ~retryLimit: int=?,
  unit,
) => clientOpts<'adapter, 'headers, 'httpAgent, 'httpsAgent, 'data>
```

### createClient
```rescript
let createClient: clientOpts<'adapter, 'headers, 'httpAgent, 'httpsAgent, 'data> => t
```
Create a contentful.js client instance.
```rescript
let client = makeClientOpts(
  ~space="<SPACE_ID>",
  ~accessToken="<TOKEN>",
  (),
)->createClient
```

### getAsset
```rescript
let getAsset: (t, string, ~query: 'query=?, unit) => Js.Promise.t<asset>
```

### getAssets
```rescript
let getAssets: (t, ~query: 'query=?, unit) => Js.Promise.t<assetCollection>
```

### getEntry
```rescript
let getEntry: (t, string) => Js.Promise.t<option<entry<'fields>>>
```

### getEntries
```rescript
let getEntries: (t, ~query: 'query=?, unit) => Js.Promise.t<entryCollection<'fields>>
```

### getContentType
```rescript
let getContentType: (t, string) => Js.Promise.t<contentType>
```

### getContentTypes
```rescript
let getContentTypes: (t, ~query: 'query=?, unit) => Js.Promise.t<contentTypeCollection>
```

### getSpace
```rescript
let getSpace: t => Js.Promise.t<space>
```

### getLocales
```rescript
let getLocales: t => Js.Promise.t<localeCollection>
```

### getTag
```rescript
let getTag: (t, string) => Js.Promise.t<tag>
```

### getTags
```rescript
let getTags: (t, ~query: 'query=?, unit) => Js.Promise.t<tagCollection>
```

### parseEntries
```rescript
let parseEntries: (t, 'raw) => Js.Promise.t<entryCollection<'fields>>
```

### sync
```rescript
let sync: (t, 'query) => Js.Promise.t<syncCollection>
```
