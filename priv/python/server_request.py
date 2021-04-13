#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import requests

api = 'AIzaSyAnikI-ix5LS_gdEEcngLhMIXW0gfgrv98'
email = 'user@example.com'
password = 'secretPassword'

FIREBASE_WEB_API_KEY = api
rest_api_url = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword"

def get_token():
    return sign_in_with_email_and_password(email, password, True)

def sign_in_with_email_and_password(email,
                                    password,
                                    return_secure_token):
    payload = json.dumps({
        "email": email,
        "password": password,
        "returnSecureToken": return_secure_token
    })

    r = requests.post(rest_api_url,
                      params={"key": FIREBASE_WEB_API_KEY},
                      data=payload)

    print('Response: \n{0}'.format(r.text))
    return r.json()['idToken']


token = str(get_token())
token = token.replace("e", "b")
r = requests.get("http://localhost:4000/auth", headers={"content-type": "application/json", "authorization": token})
print('Status code: {0}'.format(r.status_code))
print('Text: \n{0}'.format(r.text))
