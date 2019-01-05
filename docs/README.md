
[![Build Status](https://travis-ci.org/cyber-dojo/mapper.svg?branch=master)](https://travis-ci.org/cyber-dojo/mapper)
[![CircleCI](https://circleci.com/gh/cyber-dojo/mapper.svg?style=svg)](https://circleci.com/gh/cyber-dojo/mapper)

<img src="https://raw.githubusercontent.com/cyber-dojo/nginx/master/images/home_page_logo.png"
alt="cyber-dojo yin/yang logo" width="50px" height="50px"/>

# cyberdojo/mapper docker image

- A docker-containerized micro-service for [cyber-dojo](http://cyber-dojo.org).
- Holds information on practice session ids ported from
[storer](https://github.com/cyber-dojo/storer)
to
[saver](https://github.com/cyber-dojo/saver)
by
[porter](https://github.com/cyber-dojo/porter)
- Work in progress - not yet used

API:
  * All methods receive their named arguments in a json hash.
  * All methods return a json hash with a single key.
    * If the method completes, the key equals the method's name.
    * If the method raises an exception, the key equals "exception".

- [GET ready?()](#get-ready)
- [GET sha()](#get-sha)
- [GET mapped?(id6)](#get-mappedid6)
- [GET mapped_id(partial_id)](#get-mappedidpartialid)

- - - -

## GET ready?()
- parameters, none
```
  {}
```
- returns true if the service is ready, otherwise false.
```
  { "ready?": "true" }
```

- - - -

## GET sha()
Returns the git commit sha used to create the cyberdojo/porter docker image.
- parameters, none
```
  {}
```
- returns the sha, eg
```
  { "sha": "8210a96a964d462aa396464814d9e82cad99badd" }
```

- - - -

## GET mapped?(id6)
Asks if id6 matches the first 6 digits of any already ported storer
session's 10-digit id.
- parameter, a 6-digit id, eg
```
    { "id6": "55D3B9" }
```
- returns, true if it does, false if it doesn't.
```
  { "mapped?": true }
  { "mapped?": false }
```

- - - -

## GET mapped_id(partial_id)
Asks for the 6-digit (saver) id of the already ported storer
session whose 10-digit id uniquely completes the given 6-10 digit (storer) partial_id.
- parameter, a 6-10 digit storer session id, eg
```
    { "partial_id": "55D3B9" }
    { "partial_id": "55D3B97" }
    { "partial_id": "55D3B97E" }    
```
- returns the 6-digit saver id if it exists, otherwise the empty string.
```
    { "mapped_id": "55D3B9" }
    { "mapped_id": "E5pL3S" }
    { "mapped_id": "" }
```

- - - -

* [Take me to cyber-dojo's home github repo](https://github.com/cyber-dojo/cyber-dojo).
* [Take me to http://cyber-dojo.org](http://cyber-dojo.org).

![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
