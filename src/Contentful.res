type t

type tagLink = {"sys": {"type": [#Link], "linkType": [#Tag], "id": string}}

type metadata = {"tags": array<tagLink>}

type link<'linkType> = {"type": [#Link], "linkType": 'linkType, "id": string}

type contentTypeLink = link<[#ContentType]>
type spaceLink = link<[#Space]>
type environmentLink = link<[#Environment]>

type field = {
  "disabled": bool,
  "id": string,
  "linkType": option<string>,
  "localized": bool,
  "name": string,
  "omitted": bool,
  "required": bool,
  "type": [
    | #Symbol
    | #Text
    | #Integer
    | #Number
    | #Date
    | #Boolean
    | #Location
    | #Link
    | #Array
    | #Object
    | #RichText
  ],
  "validations": array<Js.Json.t>,
  "items": option<Js.Json.t>,
}

type sys = {
  "type": string,
  "id": string,
  "createdAt": string,
  "updatedAt": string,
  "locale": string,
  "revision": option<int>,
  "space": option<{
    "sys": spaceLink,
  }>,
  "environment": option<{
    "sys": environmentLink,
  }>,
  "contentType": {"sys": contentTypeLink},
}

type rec entry<'fields> = {
  "sys": sys,
  "fields": 'fields,
  "metadata": metadata,
  "toPlainObject": (. unit) => Js.Json.t,
  "update": (. unit) => Js.Promise.t<entry<'fields>>,
}

type asset = {
  "sys": sys,
  "fields": {
    "title": string,
    "description": string,
    "file": {
      "url": string,
      "details": {"size": int, "image": option<{"width": int, "height": int}>},
      "fileName": string,
      "contentType": string,
    },
  },
  "metadata": metadata,
  "toPlainObject": (. unit) => Js.Json.t,
}

type contentType = {
  "sys": sys,
  "name": string,
  "description": string,
  "displayField": string,
  "fields": array<field>,
  "toPlainObject": (. unit) => Js.Json.t,
}

type space = {
  "sys": sys,
  "name": string,
  "locales": array<string>,
  "toPlainObject": (. unit) => Js.Json.t,
}

type locale = {
  "code": string,
  "name": string,
  "default": bool,
  "fallbackCode": Js.Nullable.t<string>,
  "sys": {"id": string, "type": [#Locale], "version": int},
}

type tag = {
  "name": string,
  "sys": {"id": string, "type": [#Tag], "version": int, "visibility": [#public]},
}

type syncCollection = {
  "entries": array<entry<Js.Json.t>>,
  "assets": array<asset>,
  "deletedEntries": array<entry<Js.Json.t>>,
  "deletedAssets": array<asset>,
  "nextSyncToken": string,
  "toPlainObject": (. unit) => Js.Json.t,
  "stringifySafe": (option<Js.Json.t>, option<Js.Json.t>) => string,
}

type contentfulCollection<'a> = {
  "total": int,
  "skip": int,
  "limit": int,
  "items": array<'a>,
  "toPlainObject": (. unit) => Js.Json.t,
}

type entryCollection<'a> = {
  "total": int,
  "skip": int,
  "limit": int,
  "items": array<'a>,
  "errors": option<array<Js.Json.t>>,
  "includes": option<Js.Json.t>,
  "stringifySafe": (. option<Js.Json.t>, option<Js.Json.t>) => string,
  "toPlainObject": (. unit) => Js.Json.t,
}

type assetCollection = contentfulCollection<asset>
type contentTypeCollection = contentfulCollection<contentType>
type localeCollection = contentfulCollection<locale>
type tagCollection = contentfulCollection<tag>

type clientLogLevel = [#error | #warning | #info]

type axiosProxyConfig = {
  "host": string,
  "port": int,
  "auth": {"username": string, "password": string},
}

@obj
external makeAxiosProxyConfig: (
  ~host: string,
  ~port: int=?,
  ~auth: {"username": string, "password": string}=?,
  unit,
) => axiosProxyConfig = ""

type clientOpts<'adapter, 'headers, 'httpAgent, 'httpsAgent, 'data> = {
  "accessToken": string,
  "adapter": option<'adapter>,
  "application": option<string>,
  "basePath": option<string>,
  "environment": option<string>,
  "headers": option<'headers>,
  "host": option<string>,
  "httpAgent": option<'httpAgent>,
  "httpsAgent": option<'httpsAgent>,
  "insecure": option<bool>,
  "integration": option<string>,
  "logHandler": option<(. clientLogLevel, option<'data>) => unit>,
  "proxy": option<axiosProxyConfig>,
  "removeUnresolved": option<bool>,
  "resolveLinks": option<bool>,
  "retryLimit": option<int>,
  "retryOnError": option<bool>,
  "space": string,
  "timeout": option<int>,
}

@obj
external makeClientOpts: (
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
) => clientOpts<'adapter, 'headers, 'httpAgent, 'httpsAgent, 'data> = ""

@module("contentful")
external createClient: clientOpts<'adapter, 'headers, 'httpAgent, 'httpsAgent, 'data> => t =
  "createClient"

@send external getAsset: (t, string, ~query: 'query=?, unit) => Js.Promise.t<asset> = "getAsset"
@send external getAssets: (t, ~query: 'query=?, unit) => Js.Promise.t<assetCollection> = "getAssets"
@send external getContentType: (t, string) => Js.Promise.t<contentType> = "getContentType"
@send
external getContentTypes: (t, ~query: 'query=?, unit) => Js.Promise.t<contentTypeCollection> =
  "getContentTypes"
@send external getEntry: (t, string) => Js.Promise.t<option<entry<'fields>>> = "getEntry"
@send
external getEntries: (t, ~query: 'query=?, unit) => Js.Promise.t<entryCollection<'fields>> =
  "getEntries"
@send external getSpace: t => Js.Promise.t<space> = "getSpace"
@send external getLocales: t => Js.Promise.t<localeCollection> = "getLocales"
@send external getTag: (t, string) => Js.Promise.t<tag> = "getTag"
@send external getTags: (t, ~query: 'query=?, unit) => Js.Promise.t<tagCollection> = "getTags"
@send external parseEntries: (t, 'raw) => Js.Promise.t<entryCollection<'fields>> = "parseEntries"
@send external sync: (t, 'query) => Js.Promise.t<syncCollection> = "sync"
