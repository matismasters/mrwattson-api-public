# Mr.Wattson API Documentation

Here you will be able to find the endpoints descriptions for connecting within
Mr.Wattson's API.

At the left you'll see the list of resources and within it(onClick), the
possible actions that can be performed on them by sending HTTP requests.

## Sections

* Paramters: explains details about the expected params, including if they
are required or not
* Request > Route: shows the HTTP method and URL to use
* Request > Headers: shows the headers that need to be send on the HTTP request.
Take into consideration that both Host, and Cookie are displayed but should NOT
be sent
* Request > Body: an example of the json body content that should be sent
* Request > cURL: copy that code, change `localhost:3000` to
`mrwattson-api.herokuapp.com` and run the command in your terminal to see
the endpoint is working fine. For testing purposes you can also change the
values to what you want to test
* Response > Status: the expected response status for the sample request
* Response > Headers: the expected response headers for the sample request
* Response > Body: the expected response body for the sample request

## Data param

Particle allows to send only one custom variable when using the `Publish`
method. Thus a special format should be used when several values should be
sent.

When sending several values, the API will expect them in a specific order,
and separated by a `|` character. The order will be defined in the _Parameters_
section.

    Parameters section wills say: "value1|value2|value3|value4"

    Value of `data` should be: "10|50|Solar|Nothing4"

_Note that the separator is not at the beginning and either at the end of the
string_

When sending several groups of values, each group should be separated by the
`-` character. This character should only be between group of values, and not
at the beginning or end of the data String. When the API accepts several groups
of values it will be said in the _Parameters_ description as `MultiValue`.

    Parameters section wills say: MultiValue "value1|value2|value3|value4"

    Value of `data` for two groups should be: "10|50|Solar|Nothing4-30|29|13|4"

_Note that there is no `|` after `-`_

## Virtual parameters listed

When using compound values within one single DATA field, its clearer to add them
in the documentation as `virtual paramters`. _Virtual parameters_ will be listed
as optional parameters, and will start with a prefix `*compoundfieldname_param`.

The virtual parameters *SHOULD NOT BE PART OF THE REQUEST BODY*, they are just
explanatory, and they will be part of the `compound field name`, which will
most likely be `data`.
