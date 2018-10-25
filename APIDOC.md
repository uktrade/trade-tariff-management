# Get xml export files by date

**PATH:**

`https://#{api_path}/api/v1/taricdelta(/:date)(.:format)`

**Method**

`GET`

**URL Params**

* Required:
  * `None`

* Optional:
  * date - default value is yesterday if date is not present, format: YYYY-MM-DD, e.g. 2018-10-24
  * format - supports json only

**Success Response:**

```
[
  {
    "id": 123,
    "issue_date": "2018-10-22T12:29:08.484Z",
    "url": "http://path-to-xml-file.xml"
  }, 
  { ... },
  ...
]
```
`id` - is uniq sequence number

`issue_date` - timestamp, when xml export was initiated

`url` - path to xml file


# Get xml export file by timestamp

**PATH:**

`https://#{api_path}/api/v1/taricfile/:timestamp(.:format)`

**Method**

`GET`

**URL Params**

* Required:
  * timestamp - format: YYYYMMDDTHHMMSS, e.g. 20181024T123000

* Optional:
  * format - supports json only

**Success Response:**

```
Redirect to xml file path.
```
