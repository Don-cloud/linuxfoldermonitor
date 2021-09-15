# Filtering with jq
Handy stuff for querying the output returned by the Anypoint Runtime Manager (ARM) API (found at `https://anypoint.mulesoft.com/hybrid/api/v1`)

## What servers are in which Runtime Manager Server Group?
Ever needed a list of all server entries contained withing an ARM Server Group?

```sh
./arm-query.sh | jq '.data
 | map( select(.serverGroupName!=null) )
 | group_by(.serverGroupName)
 | map({ (.[0].serverGroupName): [ .[] |  .name ] })'
```
It returns something like this:

```javascript
[
  {
    "Group01": [
      "server-5",
      "server-2",
      "server-4"
    ]
  },
  {
    "Group02": [
      "server-4",
      "server-5"
    ]
  }
]
```

### Explanation
Let's take a look at every part, what it does (and why!) so you can quickly go out and create your own l33t queries.

`./arm-query.sh` is a bash script which calls the ARM API and feeds the JSON output (in this case all server entries) to the `jq` command which we will use for further filtering.

The JSON data returned is structured as follows; an object containing a key "data" which is an array of objects. For this example we requested/servers so it contains server entries but it could also be clusters, applications, alerts etc.

Please take a quick glance while we scroll past it on our way to the explanation of the `jq` filter (the stuff between sinqle quotes).

```javascript
{
  "data": [
    {
      "id": 1422221,
      "timeCreated": 1560000000000,
      "timeUpdated": 1560000000001,
      "name": "server-5",
      "type": "SERVER",
      "serverType": "GATEWAY",
      "muleVersion": "4.1.2",
      "gatewayVersion": "4.1.2",
      "agentVersion": "2.1.2",
      "licenseExpirationDate": 1597000000000,
      "certificateExpirationDate": 1620000000000,
      "status": "RUNNING",
      "serverGroupId": 1200000,
      "serverGroupName": "Group01",
      "addresses": [
        {
          "ip": "10.10.10.5",
          "networkInterface": "eth0"
        }
      ],
      "runtimeInformation": {
        "jvmInformation": {
          "runtime": {
            "name": "Java(TM) SE Runtime Environment",
            "version": "1.8.0_191-b12"
          },
          "specification": {
            "vendor": "Oracle Corporation",
            "name": "Java Platform API Specification",
            "version": "1.8"
          }
        },
        "osInformation": {
          "name": "Linux",
          "version": "3.10.0-957.21.3.el7.x86_64",
          "architecture": "amd64"
        },
        "muleLicenseExpirationDate": 1597622400000
      }
    },
    {
      "id": 1422222,
      "timeCreated": 1560000000000,
      "timeUpdated": 1560000000001,
      "name": "server-2",
      "type": "SERVER",
      "serverType": "GATEWAY",
      .
      .
      .
     }
  ]
}
```

The `jq` filter without quotes looks something like this (placing it here for people with short attention spans such as myself ;))

The filter is comprised of a couple of steps which I'll explain shortly below.
Please refer to 'the fine manual' at https://stedolan.github.io/jq/manual/ for more information.

```jq
.data
 | map( select(.serverGroupName!=null) )
 | group_by(.serverGroupName)
 | map({ (.[0].serverGroupName): [ .[] |  .name ] })
```

`.data` extracts the value of the "data" object, now we are left with just the array with server objects.

`| map( select( .serverGroupName != null ) )` maps over every item in the array and removes all entries which don't have the key `serverGroupName` to prevent NPE-like behaviour.

`| group_by(.serverGroupName)` groups the servers by group name. Notice that this introduces a new layer of arrays.

`| map({ (.[0].serverGroupName): [ .[] | .name ] })` maps over this array and we creates a new array with group name as key and an array of servers belonging to that group as the value.

Personally I find the above filter extremely confusing so let's break this one up a little bit further.

The _key_ is created as follows: `(.[0].serverGroupName):` we take the first item of each server group array `.[0]` and extract `.serverGroupName` and use that as a key `( ):` (note that the parentheses are mandatory (jq will inform you about it if you forget it don't worry ;)).

The _value_ is an array with objects belonging in that group `[ .[] | .name ] `
We start by creating an array `[]` and filling it by first popping out the objects from the inner array using ` .[] ` and then we feed `|` that to extract only the stuff we want `.name`

The end result looks something like this:

```javascript
[
  {
    "Group01": [
      "server-5",
      "server-2",
      "server-4"
    ]
  },
  {
    "Group02": [
      "server-4",
      "server-5"
    ]
  }
]
```

### Bonus material - objects instead of strings
Simply adjust the queries a bit and instead of creating an array of strings `[ .[] | .name]`, we can create an array of objects `[ .[] | { id: .id, name: .name, status: .status } ]` and you get:

```javascript
[
  {
    "Group01": [
      {
        "id": 1422221,
        "name": "server-5",
        "status": "RUNNING"
      },
      {
        "id": 1422222,
        "name": "server-2",
        "status": "RUNNING"
      },
      {
        "id": 1422223,
        "name": "server-4",
        "status": "RUNNING"
      }
    ]
  },
  {
    "Group02": [
      {
        "id": 1422224,
        "name": "server-4",
        "status": "RUNNING"
      },
      {
        "id": 1422225,
        "name": "server-5",
        "status": "RUNNING"
      }
    ]
  }
]
```
