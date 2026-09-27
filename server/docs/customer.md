# Customer API Spec

## Register Customer API

Endpoint : POST /api/customers/

Request Body :

```json
{
  "email" : "russypranata@gmail.com",
  "name" : "alhymni russy",
  "phone number" : "+6295338170582",
  "password": "russy@01",
  "photo" : "default.jpg",
  "token" : "token",
  "otp" : 0,
  "verified_email" : false,
//   "reset_password" : "0",
  "status" : 0,
  "last_login": "2023-01-01T12:34:56Z",
  "lat": 37.7749,
  "long": -122.4194,
  "create_datetime": "2023-01-01T12:34:56Z",
  "update_datetime": "2023-01-01T12:34:56Z"
}
```
Response Body Success :

```json
{
    "data" : {
        "email" : "russypranata@gmail.com"
    }
}
```

Response Body Error :

```json
{
    "errors" : "error fields"
}
```

## Verifikasi Email API

Endpoint : PATCH /api/users/verifikasiEmail

Request Body :

```json
{
    "otp" : "0806"
}
```

Response Body Success :

```json
{
    "data" : {
        "otp" : "0806"
    }
}
```

Response Body Error :

```json
{
    "errors" : "error otp"
}
```

## Login Customers API

Endpoint : POST /api/customers/login

Request Body :

```json
{
  "email" : "russypranata@gmail.com",
  "password" : "russy@01"
}
```


Response Body Success :

```json
{
    "data" : {
        "token" : "unique-token"
    }
}
```

Response Body Error :

```json
{
    "errors" : "error login"
}
```


## Update Customers API

Endpoint : PATCH /api/customers/current

Headers: 

- Authorization : token

Request Body :

```json
{
  "email" : "russypranata@gmail.com",
  "name" : "alhymnirussy",
  "phoneNumber" : "6295338170582",
  "photo" : "default.jpg" //optional

}
```
Response Body Success :

```json
{
    "data" : {
        "email" : "russypranata@gmail.com",
        "name" : "alhymnirussy",
        "phoneNumber" : "+6295338170582",
        "photo" : "default.jpg" //optional
    }
}
```

Response Body Error :

```json
{
    "errors" : "error update"
}
```

## Get Customer

Endpoint : get /api/customers/current

Headers: 

- Authorization : token

Response Body Success :

```json
{
    "data" : {
        "email" : "russypranata@gmail.com",
        "name" : "alhymnirussy",
        "phoneNumber" : "+6295338170582",
        "photo" : "default.jpg" 
    }
}
```

Response Body Error :

```json
{
    "errors" : "error get customer (unauthorized)"
}
```
## Logout Customer

Endpoint : DELETE /api/customers/logout

Headers: 

- Authorization : token

Response Body Success :

```json
{
    "data" : "OKE"
}
```

Response Body Error :

```json
{
    "errors" : "error get customer (unauthorized)"
}
```