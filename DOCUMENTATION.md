# API

## Contentful

Some uncommon methods and types have not yet been documented. Read the source code to find out their uses.

For a more detailed explanation of each method, lookup the [documentation for contentful.js](https://contentful.github.io/contentful.js).

### t
Type of the contentful.js fetcher client instance.
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
  // [*] ~resolveLinks: bool=?,
  // [*] ~removeUnresolved: bool=?
  ~retryOnError: bool=?,
  ~logHandler: (. clientLogLevel, option<'data>) => unit=?,
  ~timeout: int=?,
  ~retryLimit: int=?,
  unit,
) => clientOpts<'adapter, 'headers, 'httpAgent, 'httpsAgent, 'data>
```
`[*]`: `resolveLinks` and `removeUnresolved` are no longer supported in v10 of contentful.js and have therefore been removed in rescript-contentful v2. See the section on [migration](#migration) below.

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

### createAssetKey
```rescript
let createAssetKey: (t, int) => Js.Promise.t<assetKey>
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

### (getter) withoutLinkResolution
Modifies a client to render all linked entries as linked objects. [Read more on link resolution](https://github.com/contentful/contentful.js/blob/master/ADVANCED.md#link-resolution).
```rescript
let withoutLinkResolution: t => t
```
Example:
```rescript
let entries = client->withoutLinkResolution->getEntries()
```

### (getter) withoutUnresolvableLinks
Modifies a client to remove link objects from the response if linked entries are not resolvable.
```rescript
let withoutUnresolvableLinks: t => t
```

### (getter) withAllLocales
Returns a client that fetches entries in all locales.
```rescript
let withAllLocales: t => t
```

### (getter) version
```rescript
let version: t => string
```

# Migration
See also [contentful.js/MIGRATION.md](https://github.com/contentful/contentful.js/blob/master/MIGRATION.md)
## rescript-contentful v2 (contentful.js 10.x)
- `resolveLinks` and `removeUnresolved` options are removed, both as client options and as query parameters to `getEntry` and `getEntries` calls. Instead, you should use the client modifiers `withoutLinkResolution` and `withoutUnresolvableLinks` as their replacements respectively to achieve the same result.
- Calls to `getEntries` and `getEntry` no longer support setting the `locale` parameter to `'*'`. If you want to fetch entries in all locales, you should instead use the client chain `withAllLocales`.
- Client chaining examples:
```rescript
open Contentful

// returns entries in one locale, resolves linked entries, removing unresolvable links
let entries = client->withoutUnresolvableLinks->getEntries()

// returns entries in all locales, resolves linked entries, removing unresolvable links
let entries = client->withoutLinkResolution->withAllLocales->getEntries()

// returns entries in one locale, resolves linked entries, keeping unresolvable links as link object (default behavior)
let entries = client->getEntries()
```