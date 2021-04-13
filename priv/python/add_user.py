#!/usr/bin/env python
# -*- coding: utf-8 -*-

import firebase_admin
from firebase_admin import auth
from firebase_admin import credentials

cred = credentials.Certificate("/home/irina/Desktop/Find your pet/service/find-your-pet-46ea2-firebase-adminsdk-xdzmp-f31e60bd6b.json")
app = firebase_admin.initialize_app(cred)

email = 'user_not_verified@example.com'
email_verified = False
password = 'secretPassword'
name = 'John Doe'

user = auth.create_user(email=email,
                        email_verified=email_verified,
                        password=password,
                        display_name=name,
                        photo_url='http://www.example.com/12345678/photo.png',
                        disabled=False)
print('Successfully created new user: {0}'.format(user.uid))
